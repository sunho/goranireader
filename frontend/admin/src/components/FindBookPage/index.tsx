import React, { useState, useEffect, useContext } from "react";
import { useCommonStyle } from "../../style";
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
  }
});

const FindBookPage: React.FC = () => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const [data, setData] = useState<RecommendBook[]>([]);
  const classes = useStyles();

  useEffect(() => {
    (async () => {
      const raw = await firebase.dataResult(classInfo.currentId!).get();
      const res = raw.data();
      if (res && res.recommendedBooks) {
        const out = await Promise.all(
          res.recommendedBooks.map(async (doc: any) => {
            const bookd = await firebase
              .books()
              .doc(doc.bookId)
              .get();
            return {
              ...doc,
              title: bookd.data()!.title,
              cover: bookd.data()!.cover
            };
          })
        );
        setData(out as any);
      } else {
        setData([]);
      }
    })();
  }, [classInfo]);

  const suit = (book: RecommendBook) => {
    if (book.eperc > 0.5) {
      return(
      <Typography
        variant="h6"
        component="p"
          color="textPrimary"
        className={classes.text}
      >
        Need more data to decide
      </Typography>);
    }
    if (book.uperc > 0.1) {
      return (
        <Typography
          variant="h6"
        color="error"
          component="p"
          className={classes.text}
        >
          Difficult
        </Typography>
      );
    }
    return (
      <Typography
        variant="h6"
        color="primary"
        component="p"
        className={classes.text}
      >
        Suitable
      </Typography>
    );
  };

  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Typography variant="h5" className={commonStyles.header} component="h3">
        Find Book
      </Typography>
      <Grid container spacing={2}>
        {data.sort((a,b ) => (a.eperc - b.eperc)).map(book => (
          <Grid item xs={12} sm={6} md={3}>
            <Card>
              <CardMedia
                image={book.cover}
                title="book"
                className={classes.media}
              />
              <CardContent>
                <Typography gutterBottom variant="h5" component="h2">
                  {book.title}
                </Typography>
                {suit(book)}
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Container>
  );
};

export default FindBookPage;
