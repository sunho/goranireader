import React, { useState } from 'react'
import styles from './index.module.scss'
import Button from '../Button';

interface Props {
  title: string
}

const Modal: React.SFC<Props> = (props) => {
  return (
    <div className={styles.Modal}>
      <div className={styles.ModalMain}>
        <div className={styles.ModalMainTitle}>{props.title}</div>
        <div className={styles.ModalMainButtons}><Button>Okay</Button><Button gray={true}>Cancel</Button></div>
      </div>
    </div>
  )
}

export default Modal

