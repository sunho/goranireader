import React, { createContext, Context, useState } from 'react'
import Header from '../Header'
import styles from './index.module.scss'
import Sidebar from '../Sidebar'
import { Class } from '../../models';

export const ClassContext= createContext<Class>({id: -1, name: ''})

interface Props {
  side?: any
}

const Layout: React.SFC<Props> = (props) => {
  const [clas, setClas] = useState({id: -1, name: ''})
  return (
    <div className={styles.Background}>
      <ClassContext.Provider value={clas}>
        {props.side}
      </ClassContext.Provider>
      <Sidebar></Sidebar>
      <div className={styles.Container}>
        <Header setClass={setClas}></Header>
        <div className={styles.Main}>
          <div className={styles.MainContent}>
            <ClassContext.Provider value={clas}>
              {props.children}
            </ClassContext.Provider>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Layout

