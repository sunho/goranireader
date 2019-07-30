import React, { useState, useContext, useEffect } from 'react'
import styles from './index.module.scss'
import { Student } from '../../models';
import { ClassContext } from '../Layout';
import { useFetch } from '../../hooks/fetch';
import { getStudents } from '../../api';

interface Props {
}

const StudentList: React.SFC<Props> = (props) => {
  const [value, setValue] = useState("")
  const clas = useContext(ClassContext)
  const [students, setStudents] = useState<Student[]>([])
  useEffect(() => {
    const fetchData = async () => {
      if (clas.id == -1) return;
      const data = await getStudents(clas.id)
      setStudents(data)
    }
    fetchData()
  }, [clas])
  return (
    <div>
      {students && students.map(student => {
        return (
          <div>{student.name}</div>
        )
      })}
    </div>
  )
}

export default StudentList

