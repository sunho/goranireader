import React from 'react'
import {
    Container,
    Divider,
    Dropdown,
    Grid,
    Icon,
    Image,
    List,
    Menu,
    Segment,
    Visibility,
  } from 'semantic-ui-react'

const Header: React.SFC = () => (
    <div>
        <Menu
            borderless
          >
            <Menu.Item>
            <Image size='mini' src='/logo.png' />
            </Menu.Item>
            <Menu.Item header>고라니 리더 관리자</Menu.Item>

            <Menu.Menu position='right'>
            <Dropdown text='Dropdown' pointing className='link item'>
                <Dropdown.Menu>
                <Dropdown.Item>학급 1</Dropdown.Item>
                <Dropdown.Item>학급 2</Dropdown.Item>
                <Dropdown.Divider />
                <Dropdown.Item>로그아웃</Dropdown.Item>
                </Dropdown.Menu>
            </Dropdown>
            </Menu.Menu>
          </Menu>
    </div>
)

export default Header