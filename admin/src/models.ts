export interface Student {
  name: string
  complted_missions: number[]
}

export interface Mission {
  id: number
  pages: number
  class_id: number
  start_at: string
  end_at: string
}