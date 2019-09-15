import { Class } from "../../model";
import React, { useContext } from "react";
import AuthUserContext from "./context";
import { FirebaseContext } from "../Firebase";

export interface ClassInfo {
  currentId: string | null;
  classes: Class[];
  currentClass?: Class;
  setId: any;
  setLastUpdated: any;
}

export const ClasssContext = React.createContext<ClassInfo | null>(null);

export const withClass = (Component: any) => {
  const Out: React.FC<any> = props => {
    const [teacherClasses, setTeacherClasses] = React.useState<Class[] | null>(
      null
    );
    const [id, setId] = React.useState<string | null>(null);
    const [lastUpdated, setLastUpdated] = React.useState<Date>(new Date());
    const authUser = useContext(AuthUserContext)!;
    const firebase = useContext(FirebaseContext)!;
    React.useEffect(() => {
      (async () => {
        const classes = await Promise.all(
          authUser.classes.map(id =>
            firebase
              .clas(id)
              .get()
              .then(
                doc =>
                  [id, doc] as [string, firebase.firestore.DocumentSnapshot]
              )
          )
        ).then(docs =>
          docs.map(tup => {
            const [id, doc] = tup;
            if (!doc.exists) {
              throw new Error("class not exists");
            }
            return {
              id: id,
              ...doc.data()
            } as Class;
          })
        );
        setTeacherClasses(classes);
      })();
    }, [lastUpdated]);
    React.useEffect(() => {
      setId(getClassId());
    }, [teacherClasses]);
    const getClassId = () => {
      let currentUrlParams = new URLSearchParams(window.location.search);
      const id = currentUrlParams.get("class");
      if (!teacherClasses) {
        return null;
      }
      if (teacherClasses!.findIndex(it => it.id === id) === -1) {
        return teacherClasses[0] ? teacherClasses[0].id : null;
      }
      return id;
    };
    return (
      <>
        {teacherClasses && id && (
          <ClasssContext.Provider
            value={{
              classes: teacherClasses,
              currentId: id,
              currentClass: teacherClasses.find(it => it.id === id),
              setId: setId,
              setLastUpdated: setLastUpdated
            }}
          >
            <Component {...props} />
          </ClasssContext.Provider>
        )}
      </>
    );
  };
  return Out;
};
