import "semantic-ui-css/semantic.min.css"

import React from "react"
import { List, Image, Card, Button } from 'semantic-ui-react'
import Layout from '../../components/Layout'
import { useFetchApi } from '../../hooks/fetch';
import { Student as MStudent } from '../../models'

const Student: React.SFC = () => {
  const [state, fetch] = useFetchApi<MStudent[]>('https://gorani.sunho.kim/admin/missions', [{name: 'asdf'},{name: 'asdf'}])
    return (
        <div>
            <Layout>
              <Card.Group>
                {state.data.map(student => {
                    return (
                      <Card>
                        <Image src='/images/avatar/large/matthew.png' wrapped ui={false} />
                        <Card.Content>
                          <Card.Header>Matthew</Card.Header>
                          <Card.Meta>
                            <span className='date'>Joined in 2015</span>
                          </Card.Meta>
                          <Card.Description>
                              과제1 완료
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
