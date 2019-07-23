import "semantic-ui-css/semantic.min.css"

import React from "react"
import { List, Image, Card, Button } from 'semantic-ui-react'
import Layout from '../../components/Layout'
import { useFetchApi } from '../../hooks/fetch';
import { Student as MStudent } from '../../models'

const Student: React.SFC = () => {
  const [state, fetch] = useFetchApi<MStudent[]>('https://gorani.sunho.kim/admin/student', [])
    return (
        <div>
            <Layout>
              <Card.Group>
                {state.data && state.data.map(student => {
                    return (
                      <Card>
                        <Card.Content>
                          <Card.Header>{student.name}</Card.Header>
                          <Card.Description>
                            과제 상황 <br/>
                            {student.complted_missions && student.complted_missions.map(id => `과제 ${id} 완료`).join('<br/>')}
                          </Card.Description>
                        </Card.Content>
                      </Card>
                    )
                })}
              </Card.Group>
            </Layout>
        </div>
    )
}

export default Student
