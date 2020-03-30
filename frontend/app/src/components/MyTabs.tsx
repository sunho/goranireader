import { JSX as LocalJSX } from '@ionic/core';
import React from 'react';

import { NavContext } from '@ionic/react';
import { IonRouterOutlet } from '@ionic/react';

import { IonTabBar } from '@ionic/react';

interface Props extends LocalJSX.IonTabs {
  children: React.ReactNode;
  header: React.ReactElement;
  top: boolean;
}

const hostStyles: React.CSSProperties = {
  display: 'flex',
  position: 'absolute',
  top: '0',
  left: '0',
  right: '0',
  bottom: '0',
  flexDirection: 'column',
  width: '100%',
  height: '100%',
  contain: 'layout size style'
};

const tabsInner: React.CSSProperties = {
  position: 'relative',
  flex: 1,
  contain: 'layout size style'
};

export class MyTabs extends React.Component<Props> {
  context!: React.ContextType<typeof NavContext>;
  routerOutletRef: React.Ref<HTMLIonRouterOutletElement> = React.createRef();

  constructor(props: Props) {
    super(props);
  }

  render() {
    let outlet: React.ReactElement<{}> | undefined;

    React.Children.forEach(this.props.children, (child: any) => {
      if (child == null || typeof child !== 'object' || !child.hasOwnProperty('type')) {
        return;
      }
      if (child.type === IonRouterOutlet) {
        outlet = child;
      }
    });

    if (!outlet) {
      throw new Error('IonTabs must contain an IonRouterOutlet');
    }

    const header = this.props.header;

    return (
      <div style={hostStyles}>
        {this.props.top && header}
        <div style={tabsInner} className="tabs-inner">
          {outlet}
        </div>
        {(!this.props.top) && header}
      </div>
    );
  }

  static get contextType() {
    return NavContext;
  }
}
