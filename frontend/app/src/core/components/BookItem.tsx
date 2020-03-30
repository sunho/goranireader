import React from 'react';
import './BookItem.scss';
import { IonCard, IonCardHeader, IonCardSubtitle, IonCardTitle, IonCardContent, IonAvatar, IonThumbnail, IonLabel, IonItem, IonRow, IonCol } from '@ionic/react';

interface Props {
  title: string;
  cover: string;
  coverType: string;
  onClick: () => void;
}

const BookItem: React.FC<Props> = ({ title, cover, coverType, onClick }) => {
  console.log(cover, coverType);
  return (
    <IonCard button onClick={()=>{onClick()}}>
      <IonRow>
        <IonCol className="BookItem__image" size="2" sizeMd="3" sizeLg="4" style={{backgroundImage: `url('${cover}')`}}/>
        <IonCol className="BookItem__header" size="10" sizeMd="9" sizeLg="8">
          <div className="BookItem__header__box">
            <p className="BookItem__header__subtitle">{title}</p>
            <h4 className="BookItem__header__title">{title}</h4>
          </div>
        </IonCol>
      </IonRow>
    </IonCard>
  );
};

export default BookItem;
