import React from "react"
import Layout from '../../components/Layout'
import Card from "../../components/Card";
import StudentList from "../../components/StudentList";
import Modal from "../../components/Modal";

const Student: React.SFC = () => {

  return (
    <div>
      <Modal title="Add student"/>
      <Layout>
        <Card title="Students" addClick={() => {}}>
          <StudentList/>
        </Card>
      </Layout>
    </div>
  )
}

export default Student
