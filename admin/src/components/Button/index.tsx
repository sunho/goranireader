import React, { useState } from 'react'
import styles from './index.module.scss'
import classNames from 'classnames'

export interface Props {
  gray?: boolean
  onClick?: () => void
}

const Button: React.SFC<Props> = (props) => {
  return (
    <div onClick={() => {props.onClick && props.onClick()}}className={classNames({[styles.Button]:true, [styles.ButtonGray]: props.gray})}>
      {props.children}
    </div>
  )
}

export default Button

