import React, { createContext, Context, useState } from 'react'
import Header from '../Header'
import styles from './index.module.scss'
import Sidebar from '../Sidebar'
import { Class } from '../../models';

export const ClassContext= createContext<Class>({id: -1, name: ''})

const Layout: React.SFC = (props) => {
  const [clas, setClas] = useState({id: -1, name: ''})
  return (
    <div className={styles.Background}>
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

