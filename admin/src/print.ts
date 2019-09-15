import html2canvas from 'html2canvas'
import jsPdf from 'jspdf'
import logo from './logo.png'

export function printPDF(grade: string ,students: any) {
  Promise.all(students.map((student: any) => {
    const domElement = createPage(grade, student);
    document.body.append(domElement);
    const out = html2canvas(domElement, {width: 842, height: 595, scale: 3})
      .then((canvas) => canvas.toDataURL('image/jpeg'))
      .then(data => {
        document.body.removeChild(domElement);
        return data;
      });
    return out;
  })).then(datas => {
    let pdf: jsPdf | null = null;
    datas.forEach(data => {
      if (!pdf) {
        pdf = new jsPdf('l', 'px', 'a4');
      } else {
        pdf.addPage('a4', 'l');
      }
      const width = pdf.internal.pageSize.getWidth();
      const height = pdf.internal.pageSize.getHeight();
      pdf.addImage(data, 'JPEG', 0, 0, width, height);
    });
    pdf!.save('students.pdf');
  })
}

function createPage(grade: string, student: any) {
  const domElement = document.createElement('div');
  domElement.style.width = '842px';
  domElement.style.height = '595px';
  const codes = student.secretCode.split("-");
  const tagStyle = 'background: lightgray; display: inline-block; padding: 4px; border-radius: 8px;';
  domElement.innerHTML = `
    <div style="display: flex; flex-direction: column; height: 100%; padding: 20px">
      <div style="flex: 0 0; display: flex; justify-content: space-between; align-items: center">
        <div style="display: flex; align-items: center">
          <img style="max-width: 50px; " src="${logo}"/> Gorani Reader
        </div>
        <div>
          <div style="display: inline-block; padding: 4px;">${grade}</div>
          <span style="font-weight: 600">
          ${student.username}
          </span>
        </div>
      </div>
      <div style="margin-bottom: 50px; flex: 1; width: 100%; display:flex; align-items: center; justify-content: center">
        <div style="width: 300px; ">
          <div style="text-align: center; margin-bottom: 10px">
            Your secret code is
          </div>
          <div style="background: #AB7756; padding: 10px">
            <div style="padding-top: 20px; padding-bottom: 20px; background: white; text-align: center">
              <div style="${tagStyle}">
              ${codes[0] || ""}
              </div>
              <div style="${tagStyle}">
              ${codes[1] || ""}
              </div>
              <div style="${tagStyle}">
              ${codes[2] || ""}
              </div>
            </div>
          </div>
          <div style="text-align: center; margin-top: 10px">Do not let your friends see this secret code.</div>
        </div>
      </div>
      <div style="flex: 0 0">This paper was printed for an educational experiment in the CSIS (Christian Sprout Intercultural School)</div>
    <div>
  `;
  return domElement;
}
