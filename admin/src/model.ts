export interface Class {
    id: string;
    name: string;
}

export interface AdminUser {
    uid: string;
    email: string;
    admin: boolean;
    classes: string[];
}