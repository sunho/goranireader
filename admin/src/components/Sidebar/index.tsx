import React, { useState } from 'react'
import { Link } from 'gatsby'
import classNames from 'classnames'
import styles from './index.module.scss'
import CloseIcon from './close.svg'
import OpenIcon from './menu.svg'

interface MenuItemProps {
  name: string
  path: string
}

//location.pathname === path

const MenuItem: React.SFC<MenuItemProps> = ({name, path}) => (
  <Link className={styles.MenuItem} activeClassName={styles.MenuItemActive} to={path}>{name}</Link>
)

const Sidebar: React.SFC = () => {
  let [menuOpen, setMenuOpen] = useState(false);

  return (
    <nav className={classNames({[styles.Sidebar]: true, [styles.SidebarOpen]: menuOpen})}>
      <div className={styles.Header}>
        <div className={styles.Logo}>
          Gorani Reader Admin
        </div>
        <div onClick={()=>{setMenuOpen(!menuOpen)}} className={styles.ToggleButton}>
          {
            menuOpen ? <CloseIcon width='100%' height='100%'/> : <OpenIcon width='100%' height='100%'/>
          }
        </div>
      </div>
      <div className={styles.Menu}>
        <MenuItem name='Students' path='/student'/>
        <MenuItem name='Missions' path='/mission'/>
      </div>
    </nav>
  )
}

export default Sidebar
