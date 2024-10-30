export interface Message {
    id: string;
    conversationId: string;
    parentMessageId?: string;
    content: string;
    role: 'user' | 'assistant';
    version: number;
    createdAt: string;
    updatedAt: string;
  }
  
  export interface Conversation {
    id: string;
    userId: string;
    title: string;
    createdAt: string;
    updatedAt: string;
  }