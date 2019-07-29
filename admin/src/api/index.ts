import { Class, Student, MissionProgress, Mission } from "../models";
import { API_TEACHER_URL } from "./consts";

function request(method: string, body: any = undefined) {
  return {
    headers: {
      'Content-Type': 'application/json',
    },
    method: method,
    body: body ? JSON.stringify(body):undefined,
  }
}

export function getClasses(): Promise<Class[]> {
  return fetch(`${API_TEACHER_URL}/classes`)
      .then(resp => resp.json())
}

export function getStudent(id: number): Promise<Student> {
  return fetch(`${API_TEACHER_URL}/students/${id}`)
      .then(resp => resp.json())
}

export function getMission(id: number): Promise<Mission> {
  return fetch(`${API_TEACHER_URL}/missions/${id}`)
      .then(resp => resp.json())
}

export function getMissionProgresses(missionid: number): Promise<MissionProgress[]> {
  return fetch(`${API_TEACHER_URL}/missions/${missionid}/progresses`)
      .then(resp => resp.json())
}

export function putMission(id: number, mission: Mission): Promise<any> {
  return fetch(`${API_TEACHER_URL}/missinos/${id}`, request('PUT', mission))
}

export function addStudent(classid: number, studentid: number): Promise<any> {
  return fetch(`${API_TEACHER_URL}/classes/${classid}/students/${studentid}`, request('POST'))
}

export function removeStudent(classid: number, studentid: number): Promise<any> {
  return fetch(`${API_TEACHER_URL}/classes/${classid}/students/${studentid}`, request('DELETE'))
}
