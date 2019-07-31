import React, { useState, useContext, useEffect } from 'react'
import styles from './index.module.scss'
import { Student, Mission, Book } from '../../models';
import { ClassContext } from '../Layout';
import { useFetch } from '../../hooks/fetch';
import { getStudents, getMissions, getBook } from '../../api';

interface Props {
}

const MissionList: React.SFC<Props> = (props) => {
  const [value, setValue] = useState("")
  const clas = useContext(ClassContext)
  const [missions, setMissions] = useState<Mission[]>([])
  const [books, setBooks] = useState<Book[]>([])

  useEffect(() => {
    const fetchData = async () => {
      if (clas.id == -1) return;
      const data = await getMissions(clas.id)
      setMissions(data)
      const data2 = await Promise.all(data.map(mission => getBook(mission.book_id)))
      setBooks(data2)
    }
    fetchData()
  }, [clas])
  return (
    <table className={styles.table}>
      <thead>
        <tr>
          <th>BookName</th>
          <th>StartAt</th>
          <th>EndAt</th>
          <th className={styles.MissionCell}></th>
        </tr>
      </thead>
      <tbody>
      {missions && missions.map((mission, i) => {
        return (
          <tr className={styles.MissionRow}>
          <td>{(books.length > i) && books[i].name}</td>
          <td>{mission.start_at}</td>
          <td>{mission.end_at}</td>
          <td className={styles.MissionCell}>

          </td>
      </tr>
        )
      })}
      </tbody>
    </table>
  )
}

export default MissionList

