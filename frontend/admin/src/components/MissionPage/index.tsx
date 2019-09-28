import React, { useEffect } from "react";
import { useCommonStyle } from "../../style";
import {
  Container,
  Paper,
  Typography,
  Card,
  Select,
  FormControl,
  InputLabel,
  Input,
  MenuItem,
  Button,
  Grid,
  TextField,
  Chip
} from "@material-ui/core";
import MaterialTable from "material-table";
import DateFnsUtils from "@date-io/date-fns";
import {
  KeyboardDateTimePicker,
  MuiPickersUtilsProvider
} from "@material-ui/pickers";
import { ClasssContext } from "../Auth/withClass";
import { FirebaseContext } from "../Firebase";
import { firestore } from "firebase";
import { Mission, collator } from "../../model";
const uuidv4 = require("uuid/v4");

function getKeyByValue(object: any, value: any) {
  return Object.keys(object).find(key => object[key] === value);
}

const MissionPage: React.FC = () => {
  const firebase = React.useContext(FirebaseContext)!;
  const commonStyles = useCommonStyle();
  const classInfo = React.useContext(ClasssContext)!;
  const [value, setValue] = React.useState<Mission>({
    message: "",
    due: firestore.Timestamp.now(),
    id: "",
    chapters: []
  });
  const [edit, setEdit] = React.useState(false);
  const [books, setBooks] = React.useState<any[]>([]);
  const currentClass = classInfo.currentClass!;
  function handleDateChange(date: Date | null) {
    setValue({
      ...value,
      due: firestore.Timestamp.fromDate(date!)
    });
  }

  useEffect(() => {
    (async () => {
      const out = await firebase.books().get();
      setBooks(out.docs.map(doc => ({ ...doc.data(), id: doc.id })));
    })();
  }, []);

  useEffect(() => {
    if (currentClass.mission) {
      setValue(currentClass.mission);
    }
  }, [currentClass]);

  const handleInputChange = (e: any) => {
    const { name } = e.target;
    const newValue = e.target.value;
    if (name === "bookId") {
      setValue({ ...value, chapters: [], [name]: newValue });
    } else {
      setValue({ ...value, [name]: newValue });
    }
  };

  const handleChaptersChange = (e: any) => {
    const newValue = e.target.value;
    setValue({
      ...value,
      chapters: newValue
    });
  };
  const chapters =
    (books.find(x => x.id === value.bookId) || {}).chapters || {};

  const MissionComponent = (
    <form
      onSubmit={async e => {
        e.preventDefault();
        if (value.bookId && value.bookId !== "") {
          currentClass.mission = value;
          await firebase.clas(classInfo.currentId!).set(currentClass);
          classInfo.setLastUpdated(new Date());
          setEdit(false);
        }
      }}
    >
      <Grid container spacing={2}>
        <Grid item xs={12} sm={6}>
          <TextField
            disabled={!edit}
            name="message"
            value={value.message}
            onChange={handleInputChange}
            required
            fullWidth
            id="message"
            label="Message"
          />
        </Grid>
        <Grid item xs={12} sm={6}>
          <FormControl fullWidth>
            <InputLabel htmlFor="bookId">Book</InputLabel>
            <Select
              value={value.bookId || ""}
              onChange={handleInputChange}
              input={<Input disabled={!edit} name="bookId" id="bookId" />}
            >
              {books.map(book => (
                <MenuItem key={book.id} value={book.id}>
                  <em>{book.title}</em>
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Grid>
        <Grid item xs={12} sm={6}>
          <FormControl fullWidth>
            <InputLabel htmlFor="select-multiple-chip">Chapters</InputLabel>
            <Select
              multiple
              value={value.chapters}
              onChange={handleChaptersChange}
              input={<Input disabled={!edit} id="chapters" />}
              renderValue={selected => (
                <div className={commonStyles.chips}>
                  {(selected as string[])
                    .map(id => {
                      return getKeyByValue(chapters, id) as string;
                    })
                    .sort(collator.compare)
                    .map((title) => (
                      <Chip key={title} label={title} />
                    ))}
                </div>
              )}
              // MenuProps={MenuProps}
            >
              {Object.keys(chapters)
                .sort(collator.compare)
                .map(name => (
                  <MenuItem key={name} value={chapters[name]}>
                    {name}
                  </MenuItem>
                ))}
            </Select>
          </FormControl>
        </Grid>
        <Grid item xs={12} sm={6}>
          <KeyboardDateTimePicker
            disabled={!edit}
            disableToolbar
            fullWidth
            variant="inline"
            margin="normal"
            ampm={false}
            id="due"
            label="Due time"
            value={value.due.toDate()}
            onChange={handleDateChange}
            KeyboardButtonProps={{
              "aria-label": "change date"
            }}
          />
        </Grid>
        {edit ? (
          <Button type="submit" fullWidth variant="contained" color="primary">
            Okay
          </Button>
        ) : (
          <Button
            onClick={e => {
              e.preventDefault();
              setEdit(true);
            }}
            fullWidth
            variant="contained"
            color="primary"
          >
            Edit
          </Button>
        )}
      </Grid>
    </form>
  );

  return (
    <MuiPickersUtilsProvider utils={DateFnsUtils}>
      <Container maxWidth="lg" className={commonStyles.container}>
        <Typography variant="h5" className={commonStyles.header} component="h3">
          Mission
        </Typography>
        <Paper className={commonStyles.paper}>
          {currentClass.mission ? (
            MissionComponent
          ) : (
            <>
              <Button
                type="submit"
                fullWidth
                variant="contained"
                color="primary"
                onClick={async () => {
                  currentClass.mission = {
                    id: uuidv4(),
                    due: firestore.Timestamp.fromDate(
                      new Date(new Date().getTime() + 100 * 24 * 60 * 60 * 1000)
                    ),
                    message: "",
                    chapters: []
                  };
                  await firebase.clas(classInfo.currentId!).set(currentClass);
                  classInfo.setLastUpdated(new Date());
                }}
              >
                Create Mission
              </Button>
            </>
          )}
        </Paper>
      </Container>
    </MuiPickersUtilsProvider>
  );
};

export default MissionPage;
