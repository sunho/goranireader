import React, { useState, useContext } from 'react'
import Layout, { ClassContext } from '../../components/Layout'
import MissionList from '../../components/MissionList';
import Card from '../../components/Card';
import Modal from '../../components/Modal';
import moment from 'moment'
import 'moment-range'
import styles from './index.module.scss'
import 'react-input-calendar/style/index.css'
import Calendar from 'react-input-calendar'
import { useInput } from '../../hooks/input';
import { postMission } from '../../api';

interface Props {
  open: boolean
  setOpen: (arg0: boolean) => void
}

const MModal: React.SFC<Props> = (props) => {
  const clas = useContext(ClassContext)
  const { value:bookId, bind:bindBookId, reset:resetBookId } = useInput(0);
  const [ start, setStart ] = useState(moment())
  const [ end, setEnd ] = useState(moment())
  const onSubmit = async () => {
    const input = {
      'class_id': clas.id,
      'book_id': parseInt(bookId),
      'start_at': moment(start,"YYYY/MM/DD").format(),
      'end_at': moment(end,"YYYY/MM/DD").format()
    }

    await postMission(clas.id, input)
  }
  return (
    <Modal onSubmit={onSubmit} open={props.open} setOpen={props.setOpen} title="Add mission">
      <div className={styles.MissionForm}>
        <label>Book id</label>
        <input name="book_id" type='number' placeholder='Book ID' {...bindBookId} />
        <label>Start at</label>
        <Calendar format='YYYY/MM/DD' computableFormat='YYYY/MM/DD' date={start} onChange={setStart} />
        <label>End at</label>
        <Calendar format='YYYY/MM/DD' computableFormat='YYYY/MM/DD' date={end} onChange={setEnd} />
      </div>
    </Modal>
  )
}

const Mission: React.SFC = () => {
  const [open, setOpen] = useState(false);
  return (
      <div>
        <Layout side={(<MModal open={open} setOpen={setOpen}/>)}>
          <Card title="Missions" addClick={() => {setOpen(true)}}>
            <MissionList/>
          </Card>
        </Layout>
      </div>
  )
}

export default Mission
