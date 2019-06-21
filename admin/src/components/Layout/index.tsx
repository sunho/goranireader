import React from 'react'
import Header from '../Header'
import Sidebar from '../Sidebar'
import {
    Container,
    Divider,
    Dropdown,
    Grid,
    Icon,
    Image,
    List,
    Menu,
    Rail,
    Segment,
    Visibility,
  } from 'semantic-ui-react'
import styles from './index.module.scss'

const Layout: React.SFC = (props) => (
    <div>
        <Header></Header>
        <div style={{'margin-top': '20px'}}>
            <Grid container className={styles.grid}>
                <Grid.Column width={4}>
                    <Sidebar></Sidebar>
                </Grid.Column>
                <Grid.Column width={12}>
                    {props.children}
                </Grid.Column>
            </Grid>
        </div>
    </div>
)

export default Layout

