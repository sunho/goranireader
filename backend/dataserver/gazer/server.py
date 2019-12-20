###################################################################
#                                                                 #
#                    PLOT A LIVE GRAPH (PyQt5)                    #
#                  -----------------------------                  #
#            EMBED A MATPLOTLIB ANIMATION INSIDE YOUR             #
#            OWN GUI!                                             #
#                                                                 #
###################################################################

import sys
import os
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *
import functools
import numpy as np
import random as rd
import matplotlib
import base64
matplotlib.use("Qt5Agg")
from matplotlib.figure import Figure
from matplotlib.animation import TimedAnimation
from matplotlib.lines import Line2D
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
import time
import threading

name = input('name:')
agent = input('agent:')



class CustomMainWindow(QMainWindow):
    def __init__(self):
        super(CustomMainWindow, self).__init__()

        self.label = 'n'

        self.tmp = []
        self.tmp2 = []

        self.data = []
        self.ndata = []
        self.icdata = []
        self.cdata = []
        # Define the geometry of the main window
        self.setGeometry(300, 300, 1024, 800)
        self.setWindowTitle("my first window")
        # Create FRAME_A
        self.FRAME_A = QFrame(self)
        self.FRAME_A.setStyleSheet("QWidget { background-color: %s }" % QColor(210,210,235,255).name())
        self.LAYOUT_A = QGridLayout()
        self.FRAME_A.setLayout(self.LAYOUT_A)
        self.setCentralWidget(self.FRAME_A)
        # Place the zoom button
        self.zoomBtn = QPushButton(text = 'zoom')
        self.zoomBtn.setFixedSize(100, 50)
        self.zoomBtn.clicked.connect(self.zoomBtnAction)
        self.LAYOUT_A.addWidget(self.zoomBtn, *(0,0))
        # Place the matplotlib figure
        self.leftGazeFig = CustomFigCanvas()
        self.LAYOUT_A.addWidget(self.leftGazeFig, *(0,1))

        self.rightGazeFig = CustomFigCanvas()
        self.rightGazeFig.ax1.set_ylim(0, 10)
        self.LAYOUT_A.addWidget(self.rightGazeFig, *(0,2))

        self.pic = QLabel()
        self.pic.setFixedWidth(200)
        self.pic.setFixedHeight(100)
        self.LAYOUT_A.addWidget(self.pic)

        self.pic2 = QLabel()
        self.pic2.setFixedWidth(200)
        self.pic2.setFixedHeight(100)
        self.LAYOUT_A.addWidget(self.pic2)

        self.pic3 = QLabel()
        self.pic3.setFixedWidth(300)
        self.pic3.setFixedHeight(500)
        self.LAYOUT_A.addWidget(self.pic3)

        self.b2 = QPushButton('save')
        self.b2.clicked.connect(self.down)
        self.LAYOUT_A.addWidget(self.b2)

        self.b = QPushButton('switch')
        self.b.clicked.connect(self.down2)
        self.LAYOUT_A.addWidget(self.b)
        # Add the callbackfunc to ..
        myDataLoop = threading.Thread(name = 'myDataLoop', target = dataSendLoop, daemon = True, args = (self.addData_callbackFunc,self.addEvent_callbackFunc))
        myDataLoop.start()
        self.show()
        return

    def down(self):
        global name, agent
        import os
        import pickle
        if not os.path.exists('n'):
            os.makedirs('n')
        if not os.path.exists('c'):
            os.makedirs('c')
        if not os.path.exists('ic'):
            os.makedirs('ic')
        if not os.path.exists('raw'):
            os.makedirs('raw')
        with open('c/'+agent +'_' + name +'.pickle', 'wb') as handle:
            pickle.dump(self.cdata, handle, protocol=pickle.HIGHEST_PROTOCOL)
        with open('ic/'+agent +'_' + name +'.pickle', 'wb') as handle:
            pickle.dump(self.icdata, handle, protocol=pickle.HIGHEST_PROTOCOL)
        with open('n/'+agent +'_' + name +'.pickle', 'wb') as handle:
            pickle.dump(self.ndata, handle, protocol=pickle.HIGHEST_PROTOCOL)
        with open('raw/'+agent +'_' + name +'.pickle', 'wb') as handle:
            pickle.dump(self.data, handle, protocol=pickle.HIGHEST_PROTOCOL)
        print("saved")

    def down2(self):
        if self.label == 'n':
            self.label = 'c'
        elif self.label == 'c':
            self.label = 'ic'
        elif self.label == 'ic':
            self.label = 'n'
        print('label now:', self.label)

    def zoomBtnAction(self):
        print("zoom in")
        self.myFig.zoomIn(5)
        return

    def addData_callbackFunc(self, value):
        # print("Add data: " + str(value))
        self.leftGazeFig.addData((value["leftGaze"]+value["rightGaze"])/2)
        self.rightGazeFig.addData(value["leftBlink"])
        self.tmp.append([value['ms'], value['leftGaze'], value['rightGaze'], value['leftBlink']])
        self.tmp2.append([value['image'], value['leftImg'], value['rightImg'], value['ms'], value['leftGaze'], value['rightGaze'], value['leftBlink']])

        pm = QPixmap()
        pm.loadFromData(base64.b64decode(value['leftImg']))
        self.pic.setPixmap(pm.scaledToWidth(200))

        pm = QPixmap()
        pm.loadFromData(base64.b64decode(value['rightImg']))
        self.pic2.setPixmap(pm.scaledToWidth(200))

        pm = QPixmap()
        pm.loadFromData(base64.b64decode(value['image']))
        self.pic3.setPixmap(pm.scaledToWidth(300))
        return
    
    def addEvent_callbackFunc(self, event):
        if event["type"] == 'page':
            i = event['wordCount'] / (event['time'] / 1000.0)
            tmp = [x + [i] for x in self.tmp]
            if self.label == 'n':
                self.ndata.append(tmp)
            if self.label == 'ic':
                self.icdata.append(tmp)
            if self.label == 'c':
                self.cdata.append(tmp)
            self.data.append([self.tmp2, {'wordCount': event['wordCount'], 'time': event['time'], 'label': self.label, 'finds': event['finds']}])
            self.tmp = []
            self.tmp2 = []
            print("added")


class CustomFigCanvas(FigureCanvas, TimedAnimation):
    def __init__(self):
        self.addedData = []
        self.image = None
        print(matplotlib.__version__)
        # The data
        self.xlim = 200
        self.n = np.linspace(0, self.xlim - 1, self.xlim)
        a = []
        b = []
        a.append(2.0)
        a.append(4.0)
        a.append(2.0)
        b.append(4.0)
        b.append(3.0)
        b.append(4.0)
        self.y = (self.n * 0.0) + 50
        # The window
        self.fig = Figure(figsize=(5,5), dpi=100)
        self.ax1 = self.fig.add_subplot(111)
        # self.ax1 settings
        self.ax1.set_xlabel('time')
        self.ax1.set_ylabel('raw data')
        self.line1 = Line2D([], [], color='blue')
        self.line1_tail = Line2D([], [], color='red', linewidth=2)
        self.line1_head = Line2D([], [], color='red', marker='o', markeredgecolor='r')

        self.ax1.add_line(self.line1)
        self.ax1.add_line(self.line1_tail)
        self.ax1.add_line(self.line1_head)
        self.ax1.set_xlim(0, self.xlim - 1)
        self.ax1.set_ylim(0, 1)
        FigureCanvas.__init__(self, self.fig)
        TimedAnimation.__init__(self, self.fig, interval = 50, blit = True)

        return

    def new_frame_seq(self):
        return iter(range(self.n.size))

    def _init_draw(self):
        lines = [self.line1, self.line1_tail, self.line1_head]
        for l in lines:
            l.set_data([], [])
        return

    def addData(self, value):
        self.addedData.append(value)
        return

    def zoomIn(self, value):
        bottom = self.ax1.get_ylim()[0]
        top = self.ax1.get_ylim()[1]
        bottom += value
        top -= value
        self.ax1.set_ylim(bottom,top)
        self.draw()
        return

    def _step(self, *args):
        # Extends the _step() method for the TimedAnimation class.
        try:
            TimedAnimation._step(self, *args)
        except Exception as e:
            self.abc += 1
            print(str(self.abc))
            TimedAnimation._stop(self)
            pass
        return

    def _draw_frame(self, framedata):
        margin = 2
        while(len(self.addedData) > 0):
            self.y = np.roll(self.y, -1)
            self.y[-1] = self.addedData[0]
            del(self.addedData[0])


        self.line1.set_data(self.n[ 0 : self.n.size - margin ], self.y[ 0 : self.n.size - margin ])
        self.line1_tail.set_data(np.append(self.n[-10:-1 - margin], self.n[-1 - margin]), np.append(self.y[-10:-1 - margin], self.y[-1 - margin]))
        self.line1_head.set_data(self.n[-1 - margin], self.y[-1 - margin])
        self._drawn_artists = [self.line1, self.line1_tail, self.line1_head]
        return

''' End Class '''


# You need to setup a signal slot mechanism, to
# send data to your GUI in a thread-safe way.
# Believe me, if you don't do this right, things
# go very very wrong..
class Communicate(QObject):
    data_signal = pyqtSignal(dict)

''' End Class '''



def dataSendLoop(addData_callbackFunc, addEvent_callbackFunc):
    mySrc = Communicate()
    mySrc.data_signal.connect(addData_callbackFunc)
    mySrc2 = Communicate()
    mySrc2.data_signal.connect(addEvent_callbackFunc)

    from flask import Flask,  request
    app = Flask(__name__)
    @app.route('/', methods = ['POST'])
    def hello_world():
        content = request.get_json()
        y = content.get('leftGaze')
        if y is not None:
            mySrc.data_signal.emit(content)
        return 'Hello, World!'

    @app.route('/page', methods = ['POST'])
    def hello_world2():
        content = request.get_json()
        content['type'] = 'page'
        mySrc2.data_signal.emit(content)
        return 'Hello, World!'
    
    app.run(host='0.0.0.0', port=5050)
###

if __name__== '__main__':
    app = QApplication(sys.argv)
    QApplication.setStyle(QStyleFactory.create('Plastique'))
    myGUI = CustomMainWindow()
    sys.exit(app.exec_())