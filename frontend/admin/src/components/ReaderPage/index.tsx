import React, { useState, useEffect, useContext } from "react";
import { useCommonStyle } from "../../style";
import classnames from 'classnames';
import {
  Container,
  Paper,
  Typography,
  ListItem,
  List,
  ListItemAvatar,
  Avatar,
  ListItemText,
  Card,
  CardMedia,
  CardContent,
  makeStyles,
  Grid
} from "@material-ui/core";
import FolderIcon from "@material-ui/icons/Folder";
import { Report, RecommendBook } from "../../model";
import { FirebaseContext } from "../Firebase";
import { ClasssContext } from "../Auth/withClass";
import { msToString } from "../ProgressPage/tabs";

const useStyles = makeStyles({
  card: {
    width: 275
  },
  text: {
    marginBottom: 8
  },
  bullet: {
    display: "inline-block",
    margin: "0 2px",
    transform: "scale(0.8)"
  },
  title: {
    fontSize: 14
  },
  pos: {
    marginBottom: 12
  },
  media: {
    height: 0,
    paddingTop: "56.25%" // 16:9
  },
  look: {
    background: 'red'
  },
  inlin: {
    display: "inline-block",
  }
});


const pat = /([^a-zA-Z-']+)/;

const ReaderPage: React.FC = () => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const classes = useStyles();
  let currentUrlParams = new URLSearchParams(window.location.search);
  const bookid = currentUrlParams.get("bookid");
  const sid = currentUrlParams.get("sid");
  const uwords = currentUrlParams.get("uwords")!.split(',');

  useEffect(() => {
    if (book) {
      const el = document.getElementById('sentence-'+sid)!
      el.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
      });
    }
  });

  const [book, setBook] = React.useState<any|null>(null);
  useEffect(() => {
    (async () => {
      const out = await firebase.books().get();
      fetch(out.docs.filter(doc => (doc.id == bookid))[0].data()['downloadLink'])
        .then((res:any) => res.json())
        .then((out:any) => {
          setBook(out);
        });
    })();
  }, []);

  if (book) {
    const chapter = book['chapters'].filter((chap: any) => chap.items.some((sen: any) => sen.id === sid))[0];
    return (
      <Container maxWidth="lg" className={commonStyles.container}>
        <Typography variant="h5" className={commonStyles.header} component="h3">
          Reader
        </Typography>
        {
          chapter.items.map((item:any) => (
            <div id={'sentence-'+item.id}>{
              item.content.split(pat).filter((s:any) => s.length !== 0).map((word: string) => (
                <span className={classnames({[classes.look]: uwords!.includes(word) && item.id === sid})}>{word}</span>
              ))
             }
            </div>
          ))
        }
      </Container>
    );
  } else {

    return (
      <Container maxWidth="lg" className={commonStyles.container}>
        <Typography variant="h5" className={commonStyles.header} component="h3">
          Reader
        </Typography>
        <Grid container spacing={2}>
          
        </Grid>
      </Container>
    );
  }
  
  
};

export default ReaderPage;
