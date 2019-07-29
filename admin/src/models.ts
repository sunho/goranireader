export interface Student {
  id: number
  name: string
  profile: string
  mission_progress: MissionProgress
}

export interface Mission {
  id: number
  pages: number
  class_id: number
  start_at: string
  end_at: string
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
  students: Student[]
  missions: Mission[]
}