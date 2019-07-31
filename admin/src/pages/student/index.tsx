import React, { useState } from "react"
import Layout from '../../components/Layout'
import Card from "../../components/Card";
import StudentList from "../../components/StudentList";
import Modal from "../../components/Modal";

const Student: React.SFC = () => {
  const [open, setOpen] = useState(false);
  return (
    <div>
      <Modal open={open} setOpen={setOpen} title="Add student"/>
      <Layout>
        <Card title="Students" addClick={() => {setOpen(true)}}>
          <StudentList/>
        </Card>
      </Layout>
    </div>
  )
}

export default Student
