export interface Student {
  id: number
  name: string
  profile: string
  progress: number
}

export interface Mission {
  id: number
  pages: number
  book_id: number
  class_id: number
  start_at: string
  end_at: string
}

export interface Book {
  id: number
  google_id: number
  name: number
  cover: string
}

export interface MissionProgress {
  student_id: number
  mission_id: number
  progress: number
  chapters: number[]
  time: number
}

export interface Class {
  id: number
  name: string
}
