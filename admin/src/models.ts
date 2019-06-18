export interface Student {
    name: string;
}

export interface Class {
    id: number
    students: Student[]
}