import React, { useState } from 'react'
import styles from './index.module.scss'
import Add from './add.svg'

export interface SelectOption {
  name: string
  item: any
}

interface Props {
  title: string
  addClick?: () => void
}

const Card: React.SFC<Props> = (props) => {
  const [value, setValue] = useState("")
  return (
    <div className={styles.Card}>
      <div className={styles.CardHeader}>{props.title}
        {props.addClick && <Add onClick={() => {props.addClick && props.addClick()}} className={styles.CardButton}/>}
      </div>
      <div className={styles.CardMain}>
        {props.children}
      </div>
    </div>
  )
}

export default Card

