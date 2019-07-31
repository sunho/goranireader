import React, { useState } from 'react'
import styles from './index.module.scss'
import Button from '../Button';
import classNams from 'classnames'

interface Props {
  open: boolean
  setOpen: (open: boolean) => void
  onSubmit: () => void
  title: string
}

const Modal: React.SFC<Props> = (props) => {
  return (
    <div className={classNams({[styles.Modal]: true, [styles.ModalOpen]: props.open})}>
      <div className={styles.ModalMain}>
        <div className={styles.ModalMainTitle}>{props.title}</div>
          <form>
            {props.children}
            <div className={styles.ModalMainButtons}>
              <Button onClick={() => {props.onSubmit()}}>Okay</Button>
              <Button onClick={() => {props.setOpen(false)}} gray={true}>Cancel</Button>
            </div>
          </form>
      </div>
    </div>
  )
}

export default Modal

