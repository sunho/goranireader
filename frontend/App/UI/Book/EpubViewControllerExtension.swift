//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import FolioReaderKit
import ReactiveSwift
import Moya

let MinInterval: Double = 2
let MaxRate = 1.0

extension BookMainViewController: FolioReaderDelegate, FolioReaderCenterDelegate, DictViewControllerDelegate {
    func folioReaderDidAppear(_ folioReader: FolioReader) {
        dictVC.addViewToWindow()
        dictVC.delegate = self
    }
    
    func folioReaderDidClose(_ folioReader: FolioReader) {
        dictVC.removeViewFromWindow()
    }
    
    func pageDidLoad() {
        lastPage = folioReader.readerCenter!.webViewPage
        print(lastPage)
    }
    
    func selectionChanged(bookName: String, point: CGPoint, sentence: SelectedSentence?) {
        if let sentence = sentence {
            currentSentence = sentence
            dictVC.show(point, UnknownDefinitionTuple(sentence.word, currentBookId!, sentence.sentence, sentence.index))
            if currentSentences != nil && sentence.sentenceIndex < currentSentences!.count {
                var uword = FlipPageUword()
                let interval = NSDate().timeIntervalSince(lastUnknown)
                uword.interval = interval
                uword.index = sentence.index
                lastUnknown = Date()
                if currentSentences![sentence.sentenceIndex].sentence == sentence.sentence {
                    currentSentences![sentence.sentenceIndex].uwords.append(uword)
                }
            }
        } else {
            dictVC.hide()
            if let currentSentence = currentSentence {
                let payload = UnknownDefinitionPayload()
                payload.sentence = currentSentence.sentence
                payload.original = currentSentence.word
                payload.type = "epub"
                EventLogService.shared.send(payload)
            }
        }
    }

    // TODO remove
    func ask(_ text: String?) {
    }
    
    func htmlContentForPage(_ page: FolioReaderPage, htmlContent: String) -> String {
        return htmlContent
    }
    
    func dictViewControllerDidSelect(_ dictViewController: DictViewController, _ tuple: UnknownDefinitionTuple, _ word: DictEntry, _ def: DictDefinition) {
        let (total, num) = folioReader.readerContainer!.book.numberOfWord(word.word)
        if (Double(num) / Double(total)) < MaxRate {
            RealmService.shared.putUnknownWord(word, def, tuple)
        }
        
        let payload = UnknownDefinitionPayload()
        payload.sentence = tuple.sentence
        payload.word = word.word
        payload.original = tuple.word
        payload.defId = Int(def.id)
        payload.type = "epub"
        EventLogService.shared.send(payload)
    }
    
    func saveLocation(_ location: Location?) {
        if let location = location {
            let pro = RealmService.shared.getEpubProgress(currentBookId!)
            RealmService.shared.write {
                pro.updatedAt = Date()
                pro.pageNumber = location.pageNumber
                pro.offsetX = location.offsetX
                pro.offsetY = location.offsetY
                pro.progress = location.progress
            }
            let payload = ProgressBookPayload()
            payload.bookId = currentBookId!
            if location.progress > 0.8 {
                payload.completed = true
            }
            EventLogService.shared.send(payload)
        }
    }
    
    func loadLocation() -> Location? {
        let pro = RealmService.shared.getEpubProgress(currentBookId!)
        let out = Location()
        out.pageNumber = pro.pageNumber
        out.offsetX = pro.offsetX
        out.offsetY = pro.offsetY
        out.progress = pro.progress
        return out
    }
    
    func pageItemChanged(_ pageNumber: Int) {
        let chapter = folioReader.readerCenter?.currentPageNumber ?? 0
        if lastPage != pageNumber || lastChapter != chapter {
            let interval = NSDate().timeIntervalSince(lastTextUpdated)
            lastTextUpdated = Date()
            if interval > MinInterval && (lastChapter == chapter && pageNumber > lastPage || lastChapter != chapter && pageNumber == 1){
                let payload = FlipPagePayload()
                payload.bookId = currentBookId!
                payload.interval = interval
                payload.sentences = currentSentences ?? []
                payload.page = lastPage
                payload.chapter = chapter
                payload.type = "epub"
                EventLogService.shared.send(payload)
                APIService.shared.request(.getMissions)
                    .handle(ignoreError: false, type: [Mission].self) { offline, missions in
                        if !offline {
                            for mission in missions! {
                                print(mission)
                                if mission.startAt < Date() && Date() < mission.endAt {
                                    APIService.shared.request(.getMissionProgress(missionId: mission.id))
                                        .map(MissionProgress.self)
                                        .flatMapError { _ -> SignalProducer<MissionProgress, MoyaError> in
                                            return SignalProducer<MissionProgress, MoyaError>(value: MissionProgress())
                                        }.handlePlain(ignoreError: false) { offline, progress in
                                            if !offline {
                                                var progress = progress!
                                                progress.readPages =  progress.readPages + 1
                                                print(progress)
                                                APIService.shared.request(.putMissionProgress(missionId: mission.id, progress: progress)).handlePlain(ignoreError: false)
                                            }
                                    }
                                }
                            }
                        }
                }
            }
            lastPage = pageNumber
            lastChapter = chapter
        }
    }
    
    func currentText(_ sentences: [String]) {
        if let currentSentences = currentSentences {
            let same = currentSentences.map { sen -> String in
                return sen.sentence
            }.elementsEqual(sentences)
            if same {
                return
            }
        }
        lastTextUpdated = Date()
        lastUnknown = Date()
        currentSentences = sentences.map { sen in
            var out = FlipPageSentence()
            out.sentence = sen
            return out
        }
    }
}
