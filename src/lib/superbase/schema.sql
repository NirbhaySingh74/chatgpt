-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Conversations table
create table conversations (
    id uuid primary key default uuid_generate_v4(),
    user_id text references auth.users(id),
    title text,
    created_at timestamp with time zone default timezone('utc'::text, now()),
    updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Messages table
create table messages (
    id uuid primary key default uuid_generate_v4(),
    conversation_id uuid references conversations(id) on delete cascade,
    parent_message_id uuid references messages(id),
    content text not null,
    role text not null check (role in ('user', 'assistant')),
    version integer default 1,
    created_at timestamp with time zone default timezone('utc'::text, now()),
    updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Function to update conversation updated_at
create or replace function update_conversation_timestamp()
returns trigger as $$
begin
    update conversations
    set updated_at = now()
    where id = new.conversation_id;
    return new;
end;
$$ language plpgsql;

-- Trigger for updating conversation timestamp
create trigger update_conversation_timestamp
after insert or update on messages
for each row
execute function update_conversation_timestamp();