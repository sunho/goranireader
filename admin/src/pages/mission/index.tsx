import 'semantic-ui-css/semantic.min.css'

import {
    DateInput,
    TimeInput,
    DateTimeInput,
    DatesRangeInput
  } from 'semantic-ui-calendar-react';

import React from 'react'
import { List, Button, Grid, Modal, Form } from 'semantic-ui-react'
import Layout from '../../components/Layout'
import { useFetchApi } from '../../hooks/fetch';
import { Mission as MMission } from '../../models'
import { useInput } from '../../hooks/input';
import moment from 'moment'

const Mission: React.SFC = () => {
    const [state, fetchData] = useFetchApi<MMission[]>('https://gorani.sunho.kim/admin/mission', [])
    const { value:page, bind:bindPage, reset:resetPage } = useInput(0);
    const { value:start, bind:bindStart, reset:resetStart } = useInput('');
    const { value:end, bind:bindEnd, reset:resetEnd } = useInput('');

    const onSubmit = () => {
        const input = {
            'pages': parseInt(page),
            'start_at': moment(start,"DD-MM-YYYY").format(),
            'end_at': moment(end,"DD-MM-YYYY").format(),
            'class_id': 1
        }
        fetch('https://gorani.sunho.kim/admin/mission', {
            method: 'POST', // or 'PUT'
            body: JSON.stringify(input), // data can be `string` or {object}!
            headers:{
              'Content-Type': 'application/json'
            }
          }).then(() => {
            fetchData('https://gorani.sunho.kim/admin/mission?'+Math.random())
          })
    }
    return (
        <div>
            <Layout>
                <Grid>
                    <Grid.Row >
                        <Grid.Column width={16}>
                            <Modal trigger={<Button floated='right'>추가</Button>}>
                                <Modal.Header>과제 추가</Modal.Header>
                                <Modal.Content>
                                <Form onSubmit={onSubmit}>
                                    <Form.Field>
                                    <label>페이지 수</label>
                                    <input name="page" type='number' placeholder='Page Number' {...bindPage} />
                                    </Form.Field>
                                    <Form.Field>
                                    <label>시작 일</label>
                                    <DateInput
                                        name="start"
                                        placeholder="Date"
                                        iconPosition="left"
                                        {...bindStart} 
                                    />
                                    </Form.Field>
                                    <Form.Field>
                                    <label>종료 일</label>
                                    <DateInput
                                        name="end"
                                        placeholder="Date"
                                        iconPosition="left"
                                        {...bindEnd} 
                                    />
                                    </Form.Field>
                                    <Button type='submit'>Submit</Button>
                                </Form>
                                </Modal.Content>
                            </Modal>
                        </Grid.Column>
                    </Grid.Row>
                    <Grid.Row>
                        <Grid.Column width={16}>
                            <List divided relaxed >
                            {state.data && state.data.map(mission => {
                                return (
                                    <List.Item style={{'padding': '20px 0px'}}>
                                        <List.Content floated='right'>
                                            <Button onClick={()=>{
                                                fetch('https://gorani.sunho.kim/admin/mission/'+mission.id, {
                                                    method: 'delete'
                                                }).then(() => {
                                                    fetchData('https://gorani.sunho.kim/admin/mission?'+Math.random())
                                                })
                                                }}>삭제</Button>
                                        </List.Content>
                                        <List.Content>
                                            <List.Header>과제 {mission.id}</List.Header>
                                            <List.Description>{`${mission.pages}페이지를 ${moment(mission.start_at).format("MM/DD")}~${moment(mission.end_at).format("MM/DD")}사이에 읽어오기`}</List.Description>
                                        </List.Content>
                                    </List.Item>
                                )
                            })}
                            </List>
                        </Grid.Column>
                    </Grid.Row>
                </Grid>
            </Layout>
        </div>
    )
}

export default Mission