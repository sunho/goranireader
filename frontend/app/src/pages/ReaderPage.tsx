// import React, { useContext } from 'react';
// import { IonApp, IonTabs, IonRouterOutlet, IonTabBar, IonTabButton, IonIcon, IonLabel, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonVirtualScroll, IonList, IonCard, IonCardTitle, IonItem } from "@ionic/react";
// import ExploreContainer from '../components/ExploreContainer';
// import { storeContext } from '../stores/Context';
// import { useObserver } from 'mobx-react-lite';
// import { Book } from '../models';
// import Reader from '../components/reader/Reader';

// const BooksPage = () => {
//   const rootStore = useContext(storeContext);
//   // const readerStore = new ReaderStore(rootStore, );

//   const click = (book: Book) => {
//     if (!bookStore.downloaded.has(book.id)) {
//       bookStore.download(book).then(() => {bookStore.refresh().catch(() => {})});
//     } else {

//     }
//   };
//   return useObserver(() => (
//     <IonPage>
//       <IonHeader>
//         <IonToolbar>
//           <IonTitle>Books</IonTitle>
//         </IonToolbar>
//       </IonHeader>
//       <IonContent>
//         <IonHeader collapse="condense">
//           <IonToolbar>
//             <IonTitle size="large">Tab 1</IonTitle>
//           </IonToolbar>
//         </IonHeader>
//         <IonList>
//         {
//           bookStore.books.map(x => (
//           <IonItem onClick={() => {click(x)}}>
//             {x.title}
//           </IonItem>))
//         }
//         </IonList>

//       </IonContent>
//     </IonPage>
//   ));
// };

// export default BooksPage;
