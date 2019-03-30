import Foundation

extension String {
    
    var baseCandidates: [String] {
        let word = self.lowercased()
        var arr: [String] = [word]
        
        // these can be same
        if let base = irregularPasts[word] {
            arr.append(base)
        }
        if let base = irregularCompletes[word] {
            arr.append(base)
        }
        
        let suffixes = ["able", "ible", "al", "ial", "ed", "en", "en", "er", "est", "ful", "ic", "ing", "ion", "tion", "ation", "ition", "ity", "ty", "ive", "ative", "itive", "less", "ly", "ment", "ness", "ous", "eous", "ious", "s", "es", "y"]
        
        for suffix in suffixes {
            if let word = word.trimmingSuffix("y" + suffix) {
                arr.append(word + "ie")
            }
            
            if let word = word.trimmingSuffix("i" + suffix) {
                arr.append(word + "y")
            }
            
            if let word = word.trimmingSuffix("al" + suffix) {
                arr.append(word)
            }
            
            if let word = word.trimmingSuffix(suffix) {
                arr.append(word + "e")
                if  word.count >= 2 &&
                    word.charAtBack(1) == word.charAtBack(2) {
                    // get -> getting
                    arr.append(word.trimming(1))
                }
                // go -> going
                arr.append(word)
                arr.append(word + "le")
                arr.append(word + "y")
            }
        }
        
        return arr.unique
    }
}




// https://en.wikipedia.org/wiki/List_of_English_irregular_verbs

fileprivate let irregularPasts = ["ached":"ache","oke":"ache","was":"be","were":"be","bore":"bear","bare":"bear","forbore":"forbear","forbare":"forbear","misbore":"misbear","misbare":"misbear","overbore":"overbear","overbare":"overbear","underbore":"underbear","underbare":"underbear","became":"become","misbecame":"misbecome","begot":"beget","begat":"beget","misbegot":"misbeget","misbegat":"misbeget","began":"begin","bent":"bend","bended":"bend","overbent":"overbend","overbended":"overbend","unbent":"unbend","unbended":"unbend","beseeched":"beseech","besought":"beseech","betted":"bet","underbetted":"underbet","bade":"bid","bided":"bide","bode":"bide","abided":"abide","abode":"abide","bound":"bind","unbound":"unbind","underbound":"underbind","bit":"bite","frostbit":"frostbite","bled":"bleed","blessed":"bless","blest":"bless","blew":"blow","overblew":"overblow","broke":"break","outbroke":"outbreak","rebroke":"rebreak","bred":"breed","inbred":"inbreed","interbred":"interbreed","overbred":"overbreed","brought":"bring","built":"build","overbuilt":"overbuild","rebuilt":"rebuild","underbuilt":"underbuild","burned":"burn","burnt":"burn","sunburned":"sunburn","sunburnt":"sunburn","brast":"burst","busted":"bust","bought":"buy","abought":"abuy","overbought":"overbuy","underbought":"underbuy","could":"can","caught":"catch","chided":"chide","chid":"chide","chode":"chide","chose":"choose","mischose":"mischoose","clapped":"clap","clapt":"clap","cleft":"cleave","clove":"cleave","cleaved":"cleave","clave":"cleave","cleped":"clepe","clepen":"clepe","clept":"clepe","clung":"cling","clothed":"clothe","overclad":"overclothe","overclothed":"overclothe","unclad":"unclothe","unclothed":"unclothe","underclad":"underclothe","underclothed":"underclothe","combed":"comb","came":"come","forthcame":"forthcome","overcame":"overcome","costed":"cost","crept":"creep","creeped":"creep","crope":"creep","crowed":"crow","crew":"crow","dared":"dare","durst":"dare","dealt":"deal","misdealt":"misdeal","redealt":"redeal","dug":"dig","digged":"dig","underdug":"underdig","dived":"dive","dove":"dive","did":"do","bedid":"bedo","fordid":"fordo","misdid":"misdo","outdid":"outdo","overdid":"overdo","redid":"redo","underdid":"underdo","undid":"undo","dowed":"dow","dought":"dow","dragged":"drag","drug":"drag","drew":"draw","adrew":"adraw","bedrew":"bedraw","downdrew":"downdraw","outdrew":"outdraw","overdrew":"overdraw","redrew":"redraw","umbedrew":"umbedraw","underdrew":"underdraw","updrew":"updraw","withdrew":"withdraw","dreamed":"dream","dreamt":"dream","drempt":"dream","bedreamed":"bedream","bedreamt":"bedream","dressed":"dress","drest":"dress","drank":"drink","drunk":"drink","drinked":"drink","outdrank":"outdrink","outdrunk":"outdrink","outdrinked":"outdrink","overdrank":"overdrink","overdrunk":"overdrink","overdrinked":"overdrink","drove":"drive","drave":"drive","bedrove":"bedrive","overdrove":"overdrive","overdrave":"overdrive","test-drove":"test-drive","test-drave":"test-drive","dwelt":"dwell","dwelled":"dwell","bedwelt":"bedwell","bedwelled":"bedwell","outdwelt":"outdwell","outdwelled":"outdwell","earned":"earn","earnt":"earn","ate":"eat","et":"eat","forfretted":"forfret","fretted":"fret","frate":"fret","outate":"outeat","overate":"overeat","overet":"overeat","underate":"undereat","underet":"undereat","fell":"fall","felled":"fall","befell":"befall","befelled":"befall","misbefell":"misbefall","misbefelled":"misbefall","misfell":"misfall","misfelled":"misfall","outfell":"outfall","fed":"feed","bottle-fed":"bottle-feed","breastfed":"breastfeed","force-fed":"force-feed","hand-fed":"hand-feed","misfed":"misfeed","overfed":"overfeed","self-fed":"self-feed","spoon-fed":"spoon-feed","underfed":"underfeed","felt":"feel","forefelt":"forefeel","fought":"fight","befought":"befight","outfought":"outfight","found":"find","fand":"find","refound":"refind","refand":"refind","fitted":"fit","misfitted":"misfit","fled":"flee","flung":"fling","flew":"fly","outflew":"outfly","overflew":"overfly","test-flew":"test-fly","forbade":"forbid","forbad":"forbid","forgot":"forget","forgat":"forget","forlore":"forlese","forsook":"forsake","froze":"freeze","quick-froze":"quick-freeze","refroze":"refreeze","unfroze":"unfreeze","got":"get","gat":"get","misgot":"misget","misgat":"misget","overgot":"overget","overgat":"overget","undergot":"underget","undergat":"underget","gilded":"gild","gilt":"gild","girded":"gird","girt":"gird","undergirded":"undergird","undergirt":"undergird","gave":"give","forgave":"forgive","misgave":"misgive","overgave":"overgive","went":"go","bewent":"bego","forewent":"forego","forwent":"forgo","overwent":"overgo","underwent":"undergo","withwent":"withgo","grove":"grave","graved":"grave","ground":"grind","grinded":"grind","grew":"grow","growed":"grow","outgrew":"outgrow","outgrowed":"outgrow","overgrew":"overgrow","overgrowed":"overgrow","regrew":"regrow","regrowed":"regrow","undergrew":"undergrow","undergrowed":"undergrow","upgrew":"upgrow","upgrowed":"upgrow","hung":"hang","hanged":"hang","overhung":"overhang","overhanged":"overhang","underhung":"underhang","underhanged":"underhang","uphung":"uphang","uphanged":"uphang","had":"have","heard":"hear","beheard":"behear","foreheard":"forehear","misheard":"mishear","outheard":"outhear","overheard":"overhear","reheard":"rehear","unheard":"unhear","heaved":"heave","hove":"heave","upheaved":"upheave","uphove":"upheave","helped":"help","holp":"help","hewed":"hew","underhewed":"underhew","hid":"hide","hoisted":"hoist","held":"hold","beheld":"behold","inheld":"inhold","misheld":"mishold","upheld":"uphold","withheld":"withhold","kept":"keep","miskept":"miskeep","overkept":"overkeep","underkept":"underkeep","kenned":"ken","kent":"ken","bekenned":"beken","bekent":"beken","forekenned":"foreken","forekent":"foreken","miskenned":"misken","miskent":"misken","outkenned":"outken","outkent":"outken","knelt":"kneel","kneeled":"kneel","knitted":"knit","beknitted":"beknit","hand-knitted":"hand-knit","knew":"know","acknew":"acknow","foreknew":"foreknow","misknew":"misknow","laded":"lade","overladed":"overlade","laughed":"laugh","laught":"laugh","laugh’d":"laugh","low":"laugh","laid":"lay","layed":"lay","belaid":"belay","belayed":"belay","forelaid":"forelay","forelayed":"forelay","forlaid":"forlay","forlayed":"forlay","inlaid":"inlay","inlayed":"inlay","interlaid":"interlay","interlayed":"interlay","mislaid":"mislay","mislayed":"mislay","onlaid":"onlay","onlayed":"onlay","outlaid":"outlay","outlayed":"outlay","overlaid":"overlay","overlayed":"overlay","re-laid":"re-lay","re-layed":"re-lay","underlaid":"underlay","underlayed":"underlay","unlaid":"unlay","unlayed":"unlay","uplaid":"uplay","uplayed":"uplay","waylaid":"waylay","waylayed":"waylay","led":"lead","beled":"belead","forthled":"forthlead","inled":"inlead","misled":"mislead","offled":"offlead","onled":"onlead","outled":"outlead","overled":"overlead","underled":"underlead","upled":"uplead","leaned":"lean","leant":"lean","leaped":"leap","leapt":"leap","lept":"leap","lope":"leap","beleaped":"beleap","beleapt":"beleap","belept":"beleap","belope":"beleap","forthleaped":"forthleap","forthleapt":"forthleap","forthlept":"forthleap","forthlope":"forthleap","outleaped":"outleap","outleapt":"outleap","outlept":"outleap","outlope":"outleap","overleaped":"overleap","overleapt":"overleap","overlept":"overleap","overlope":"overleap","learned":"learn","learnt":"learn","mislearned":"mislearn","mislearnt":"mislearn","overlearned":"overlearn","overlearnt":"overlearn","relearned":"relearn","relearnt":"relearn","unlearned":"unlearn","unlearnt":"unlearn","left":"leave","beleft":"beleave","forleft":"forleave","overleft":"overleave","lent":"lend","forlent":"forlend","leet":"let","forleet":"forlet","subleet":"sublet","underleet":"underlet","lay":"lie","forelay":"forelie","forlay":"forlie","overlay":"overlie","underlay":"underlie","lit":"light","lighted":"light","alit":"alight","alighted":"alight","backlit":"backlight","backlighted":"backlight","green-lit":"green-light","green-lighted":"green-light","relit":"relight","relighted":"relight","lost":"lose","made":"make","remade":"remake","unmade":"unmake","might":"may","meant":"mean","met":"meet","melted":"melt","molt":"melt","mixed":"mix","mixt":"mix","mowed":"mow","needed":"need","paid":"pay","payed":"pay","overpaid":"overpay","overpayed":"overpay","prepaid":"prepay","prepayed":"prepay","repaid":"repay","repayed":"repay","underpaid":"underpay","underpayed":"underpay","penned":"pen","pent":"pen","pled":"plead","pleaded":"plead","proved":"prove","reproved":"reprove","bequeathed":"bequeath","bequethed":"bequeath","bequoth":"bequeath","bequod":"bequeath","quitted":"quit","reached":"reach","raught":"reach","rought":"reach","retcht":"reach","reaved":"reave","reft":"reave","bereaved":"bereave","bereft":"bereave","rent":"rend","ridded":"rid","rode":"ride","outrode":"outride","outrid":"outride","overrode":"override","overrid":"override","rang":"ring","rung":"ring","rose":"rise","arose":"arise","uprose":"uprise","rived":"rive","rove":"rive","ran":"run","foreran":"forerun","outran":"outrun","overran":"overrun","reran":"rerun","underran":"underrun","sawed":"saw","said":"say","forsaid":"forsay","gainsaid":"gainsay","missaid":"missay","naysaid":"naysay","soothsaid":"soothsay","withsaid":"withsay","saw":"see","besaw":"besee","foresaw":"foresee","missaw":"missee","oversaw":"oversee","sightsaw":"sightsee","undersaw":"undersee","sought":"seek","seethed":"seethe","sod":"seethe","sold":"sell","outsold":"outsell","oversold":"oversell","resold":"resell","undersold":"undersell","upsold":"upsell","sent":"send","missent":"missend","resent":"resend","sewed":"sew","handsewed":"handsew","oversewed":"oversew","shook":"shake","overshook":"overshake","should":"shall","shaped":"shape","shope":"shape","forshaped":"forshape","forshope":"forshape","misshaped":"misshape","misshope":"misshape","shaved":"shave","shove":"shave","sheared":"shear","shore":"shear","shone":"shine","shined":"shine","beshone":"beshine","beshined":"beshine","shitted":"shit","shat":"shit","shited":"shite","shod":"shoe","shoed":"shoe","reshod":"reshoe","reshoed":"reshoe","shot":"shoot","misshot":"misshoot","overshot":"overshoot","reshot":"reshoot","undershot":"undershoot","showed":"show","shew":"show","foreshowed":"foreshow","foreshew":"foreshow","reshowed":"reshow","reshew":"reshow","shrank":"shrink","shrunk":"shrink","overshrank":"overshrink","overshrunk":"overshrink","shrived":"shrive","shrove":"shrive","sang":"sing","resang":"resing","sank":"sink","sunk":"sink","sat":"sit","sate":"sit","babysat":"babysit","babysate":"babysit","housesat":"housesit","housesate":"housesit","resat":"resit","resate":"resit","withsat":"withsit","withsate":"withsit","slew":"slay","slayed":"slay","slept":"sleep","overslept":"oversleep","underslept":"undersleep","slid":"slide","backslid":"backslide","overslid":"overslide","slung":"sling","slang":"sling","slunk":"slink","slinked":"slink","slank":"slink","slipped":"slip","slipt":"slip","overslipped":"overslip","overslipt":"overslip","smelled":"smell","smelt":"smell","smote":"smite","smit":"smite","sneaked":"sneak","snuck":"sneak","sowed":"sow","sew":"sow","spoke":"speak","spake":"speak","bespoke":"bespeak","bespake":"bespeak","forespoke":"forespeak","forespake":"forespeak","forspoke":"forspeak","forspake":"forspeak","misspoke":"misspeak","misspake":"misspeak","sped":"speed","speeded":"speed","spelled":"spell","spelt":"spell","misspelled":"misspell","misspelt":"misspell","spent":"spend","forspent":"forspend","misspent":"misspend","outspent":"outspend","overspent":"overspend","spilled":"spill","spilt":"spill","overspilled":"overspill","overspilt":"overspill","spun":"spin","span":"spin","outspun":"outspin","outspan":"outspin","spat":"spit","spoiled":"spoil","spoilt":"spoil","spreaded":"spread","bespreaded":"bespread","sprang":"spring","sprung":"spring","handsprang":"handspring","handsprung":"handspring","stood":"stand","forstood":"forstand","misunderstood":"misunderstand","overstood":"overstand","understood":"understand","upstood":"upstand","withstood":"withstand","starved":"starve","starf":"starve","storve":"starve","stove":"stave","staved":"stave","stayed":"stay","staid":"stay","stole":"steal","stuck":"stick","sticked":"stick","stung":"sting","stang":"sting","stank":"stink","stunk":"stink","stretched":"stretch","straught":"stretch","straight":"stretch","strewed":"strew","bestrewed":"bestrew","overstrewed":"overstrew","strode":"stride","strided":"stride","bestrode":"bestride","bestrided":"bestride","outstrode":"outstride","outstrided":"outstride","overstrode":"overstride","overstrided":"overstride","struck":"strike","overstruck":"overstrike","strung":"string","stringed":"string","hamstrung":"hamstring","hamstringed":"hamstring","overstrung":"overstring","overstringed":"overstring","stripped":"strip","stript":"strip","strove":"strive","strived":"strive","outstrove":"outstrive","overstrove":"overstrive","swore":"swear","forswore":"forswear","outswore":"outswear","sweated":"sweat","swept":"sweep","sweeped":"sweep","upswept":"upsweep","upsweeped":"upsweep","swelled":"swell","swole":"swell","swelt":"swell","upswelled":"upswell","upswole":"upswell","upswelt":"upswell","swelted":"swelt","swolt":"swelt","swam":"swim","swum":"swim","outswam":"outswim","outswum":"outswim","swang":"swing","swung":"swing","overswang":"overswing","overswung":"overswing","swank":"swink","swonk":"swink","swinkt":"swink","swinked":"swink","forswank":"forswink","forswonk":"forswink","toswank":"toswink","took":"take","taked":"take","betook":"betake","betaked":"betake","intook":"intake","intaked":"intake","mistook":"mistake","mistaked":"mistake","overtook":"overtake","overtaked":"overtake","partook":"partake","partaked":"partake","retook":"retake","retaked":"retake","undertook":"undertake","undertaked":"undertake","uptook":"uptake","uptaked":"uptake","withtook":"withtake","taught":"teach","teached":"teach","tore":"tear","uptore":"uptear","teed":"tee","tow":"tee","beteed":"betee","betow":"betee","forteed":"fortee","fortow":"fortee","told":"tell","telled":"tell","foretold":"foretell","foretelled":"foretell","forthtold":"forthtell","mistold":"mistell","outtold":"outtell","outtelled":"outtell","retold":"retell","retelled":"retell","thought":"think","thinked":"think","outthought":"outthink","outthinked":"outthink","rethought":"rethink","rethinked":"rethink","throve":"thrive","thrived":"thrive","thrave":"thrive","threw":"throw","throwed":"throw","misthrew":"misthrow","misthrowed":"misthrow","outthrew":"outthrow","outthrowed":"outthrow","overthrew":"overthrow","overthrowed":"overthrow","underthrew":"underthrow","underthrowed":"underthrow","upthrew":"upthrow","upthrowed":"upthrow","thrusted":"thrust","outthrusted":"outthrust","trod":"tread","treaded":"tread","trodden":"tread","retrod":"retread","retreaded":"retread","retrodden":"retread","vexed":"vex","vext":"vex","woke":"wake","waked":"wake","awoke":"awake","awaked":"awake","waxed":"wax","wex":"wax","weared":"wear","wore":"wear","forweared":"forwear","forwore":"forwear","outweared":"outwear","outwore":"outwear","overweared":"overwear","overwore":"overwear","wove":"weave","interwove":"interweave","unwove":"unweave","wedded":"wed","miswedded":"miswed","rewedded":"rewed","wept":"weep","weeped":"weep","bewept":"beweep","beweeped":"beweep","wended":"wend","wetted":"wet","overwetted":"overwet","would":"will","won":"win","wound":"wind","rewound":"rewind","unwound":"unwind","worked":"work","wrought":"work","overworked":"overwork","overwrought":"overwork","worthed":"worth","wreaked":"wreak","wrack":"wreak","wroke":"wreak","wrang":"wring","wrung":"wring","wringed":"wring","wrote":"write","writ":"write","cowrote":"cowrite","ghostwrote":"ghostwrite","ghostwrit":"ghostwrite","handwrote":"handwrite","handwrit":"handwrite","miswrote":"miswrite","miswrit":"miswrite","overwrote":"overwrite","overwrit":"overwrite","rewrote":"rewrite","rewrit":"rewrite","underwrote":"underwrite","underwrit":"underwrite","writhed":"writhe","wrothe":"writhe","zinced":"zinc","zinked":"zinc","zincked":"zinc"]

fileprivate let irregularCompletes = ["ached":"ache","aken":"ache","been":"be","borne":"bear","born":"bear","forborne":"forbear","forborn":"forbear","misborne":"misbear","misborn":"misbear","overborne":"overbear","overborn":"overbear","underborne":"underbear","underborn":"underbear","beaten":"beat","browbeaten":"browbeat","overbeaten":"overbeat","begot":"beget","begotten":"beget","misbegotten":"misbeget","misbegot":"misbeget","begun":"begin","bent":"bend","bended":"bend","overbent":"overbend","overbended":"overbend","unbent":"unbend","unbended":"unbend","beseeched":"beseech","besought":"beseech","betted":"bet","underbetted":"underbet","bidden":"bid","bided":"bide","abided":"abide","abidden":"abide","bound":"bind","unbound":"unbind","underbound":"underbind","bitten":"bite","frostbitten":"frostbite","bled":"bleed","blessed":"bless","blest":"bless","blown":"blow","overblown":"overblow","broken":"break","outbroken":"outbreak","rebroken":"rebreak","bred":"breed","inbred":"inbreed","interbred":"interbreed","overbred":"overbreed","brought":"bring","built":"build","overbuilt":"overbuild","rebuilt":"rebuild","underbuilt":"underbuild","burned":"burn","burnt":"burn","sunburned":"sunburn","sunburnt":"sunburn","bursten":"burst","busted":"bust","bought":"buy","boughten":"buy","abought":"abuy","overbought":"overbuy","underbought":"underbuy","caught":"catch","chided":"chide","chid":"chide","chidden":"chide","chosen":"choose","mischosen":"mischoose","clapped":"clap","clapt":"clap","cleft":"cleave","cloven":"cleave","cleaved":"cleave","cleped":"clepe","clept":"clepe","clepen":"clepe","yclept":"clepe","clung":"cling","clothed":"clothe","overclad":"overclothe","overclothed":"overclothe","unclad":"unclothe","unclothed":"unclothe","underclad":"underclothe","underclothed":"underclothe","combed":"comb","kempt":"comb","comen":"come","overcomen":"overcome","costed":"cost","crept":"creep","creeped":"creep","cropen":"creep","crowed":"crow","crown":"crow","dared":"dare","dealt":"deal","misdealt":"misdeal","redealt":"redeal","dug":"dig","digged":"dig","underdug":"underdig","dived":"dive","dove":"dive","done":"do","bedone":"bedo","fordone":"fordo","misdone":"misdo","outdone":"outdo","overdone":"overdo","redone":"redo","underdone":"underdo","undone":"undo","dowed":"dow","dought":"dow","dragged":"drag","drug":"drag","drawn":"draw","adrawn":"adraw","bedrawn":"bedraw","downdrawn":"downdraw","outdrawn":"outdraw","overdrawn":"overdraw","redrawn":"redraw","umbedrawn":"umbedraw","underdrawn":"underdraw","uprawn":"updraw","withdrawn":"withdraw","dreamed":"dream","dreamt":"dream","drempt":"dream","bedreamed":"bedream","bedreamt":"bedream","dressed":"dress","drest":"dress","drunk":"drink","drank":"drink","drinked":"drink","drunken":"drink","outdrunk":"outdrink","outdrank":"outdrink","outdrinked":"outdrink","outdrunken":"outdrink","overdrunk":"overdrink","overdrank":"overdrink","overdrinked":"overdrink","overdrunken":"overdrink","driven":"drive","bedriven":"bedrive","overdriven":"overdrive","test-driven":"test-drive","dwelt":"dwell","dwelled":"dwell","bedwelt":"bedwell","bedwelled":"bedwell","outdwelt":"outdwell","outdwelled":"outdwell","earned":"earn","earnt":"earn","eaten":"eat","forfretted":"forfret","forfretten":"forfret","fretted":"fret","fretten":"fret","outeaten":"outeat","overeaten":"overeat","undereaten":"undereat","fallen":"fall","felled":"fall","befallen":"befall","befelled":"befall","misbefallen":"misbefall","misbefelled":"misbefall","misfallen":"misfall","misfelled":"misfall","outfallen":"outfall","fed":"feed","bottle-fed":"bottle-feed","breastfed":"breastfeed","force-fed":"force-feed","hand-fed":"hand-feed","misfed":"misfeed","overfed":"overfeed","self-fed":"self-feed","spoon-fed":"spoon-feed","underfed":"underfeed","felt":"feel","forefelt":"forefeel","fought":"fight","foughten":"fight","befought":"befight","outfought":"outfight","found":"find","founden":"find","refound":"refind","refounden":"refind","fitted":"fit","misfitted":"misfit","fled":"flee","flung":"fling","flown":"fly","outflown":"outfly","overflown":"overfly","test-flown":"test-fly","forbidden":"forbid","forgotten":"forget","forgot":"forget","forlorn":"forlese","forsaken":"forsake","frozen":"freeze","quick-frozen":"quick-freeze","refrozen":"refreeze","unfrozen":"unfreeze","got":"get","gotten":"get","misgot":"misget","misgotten":"misget","overgot":"overget","overgotten":"overget","undergot":"underget","undergotten":"underget","gilded":"gild","gilt":"gild","girded":"gird","girt":"gird","undergirded":"undergird","undergirt":"undergird","given":"give","forgiven":"forgive","misgiven":"misgive","overgiven":"overgive","gone":"go","begone":"bego","foregone":"forego","forgone":"forgo","overgone":"overgo","undergone":"undergo","withgone":"withgo","graven":"grave","graved":"grave","ground":"grind","grinded":"grind","grounden":"grind","grown":"grow","growed":"grow","outgrown":"outgrow","outgrowed":"outgrow","overgrown":"overgrow","overgrowed":"overgrow","regrown":"regrow","regrowed":"regrow","undergrown":"undergrow","undergrowed":"undergrow","upgrown":"upgrow","upgrowed":"upgrow","hung":"hang","hanged":"hang","overhung":"overhang","overhanged":"overhang","underhung":"underhang","underhanged":"underhang","uphung":"uphang","uphanged":"uphang","had":"have","heard":"hear","beheard":"behear","foreheard":"forehear","misheard":"mishear","outheard":"outhear","overheard":"overhear","reheard":"rehear","unheard":"unhear","heaved":"heave","hove":"heave","hoven":"heave","upheaved":"upheave","uphove":"upheave","uphoven":"upheave","helped":"help","holpen":"help","hewed":"hew","hewn":"hew","underhewed":"underhew","underhewn":"underhew","hidden":"hide","hid":"hide","hoisted":"hoist","held":"hold","holden":"hold","beheld":"behold","beholden":"behold","inheld":"inhold","inholden":"inhold","misheld":"mishold","misholden":"mishold","upheld":"uphold","upholden":"uphold","withheld":"withhold","withholden":"withhold","kept":"keep","miskept":"miskeep","overkept":"overkeep","underkept":"underkeep","kenned":"ken","kent":"ken","bekenned":"beken","bekent":"beken","forekenned":"foreken","forekent":"foreken","miskenned":"misken","miskent":"misken","outkenned":"outken","outkent":"outken","knelt":"kneel","kneeled":"kneel","knitted":"knit","beknitted":"beknit","hand-knitted":"hand-knit","known":"know","knowen":"know","acknown":"acknow","acknowen":"acknow","foreknown":"foreknow","foreknowen":"foreknow","misknown":"misknow","misknowen":"misknow","laden":"lade","laded":"lade","overladen":"overlade","overladed":"overlade","laughed":"laugh","laught":"laugh","laugh’d":"laugh","laughen":"laugh","laid":"lay","layed":"lay","belaid":"belay","belayed":"belay","forelaid":"forelay","forelayed":"forelay","forlaid":"forlay","forlayed":"forlay","inlaid":"inlay","inlayed":"inlay","interlaid":"interlay","interlayed":"interlay","mislaid":"mislay","mislayed":"mislay","onlaid":"onlay","onlayed":"onlay","outlaid":"outlay","outlayed":"outlay","overlaid":"overlay","overlayed":"overlay","re-laid":"re-lay","re-layed":"re-lay","underlaid":"underlay","underlayed":"underlay","unlaid":"unlay","unlayed":"unlay","uplaid":"uplay","uplayed":"uplay","waylaid":"waylay","waylayed":"waylay","led":"lead","beled":"belead","forthled":"forthlead","inled":"inlead","misled":"mislead","offled":"offlead","onled":"onlead","outled":"outlead","overled":"overlead","underled":"underlead","upled":"uplead","leaned":"lean","leant":"lean","leaped":"leap","leapt":"leap","lopen":"leap","beleaped":"beleap","beleapt":"beleap","belopen":"beleap","forthleaped":"forthleap","forthleapt":"forthleap","forthlopen":"forthleap","outleaped":"outleap","outleapt":"outleap","outlopen":"outleap","overleaped":"overleap","overleapt":"overleap","overlopen":"overleap","learned":"learn","learnt":"learn","mislearned":"mislearn","mislearnt":"mislearn","overlearned":"overlearn","overlearnt":"overlearn","relearned":"relearn","relearnt":"relearn","unlearned":"unlearn","unlearnt":"unlearn","left":"leave","laft":"leave","beleft":"beleave","belaft":"beleave","forleft":"forleave","forlaft":"forleave","overleft":"overleave","overlaft":"overleave","lent":"lend","forlent":"forlend","letten":"let","forletten":"forlet","subletten":"sublet","underletten":"underlet","lain":"lie","forelain":"forelie","forlain":"forlie","overlain":"overlie","underlain":"underlie","lit":"light","lighted":"light","alit":"alight","alighted":"alight","backlit":"backlight","backlighted":"backlight","green-lit":"green-light","green-lighted":"green-light","relit":"relight","relighted":"relight","lost":"lose","made":"make","remade":"remake","unmade":"unmake","meant":"mean","met":"meet","melted":"melt","molten":"melt","mixed":"mix","mixt":"mix","mowed":"mow","mown":"mow","needed":"need","paid":"pay","payed":"pay","overpaid":"overpay","overpayed":"overpay","prepaid":"prepay","prepayed":"prepay","repaid":"repay","repayed":"repay","underpaid":"underpay","underpayed":"underpay","penned":"pen","pent":"pen","pled":"plead","pleaded":"plead","proved":"prove","proven":"prove","reproved":"reprove","reproven":"reprove","putten":"put","inputten":"input","outputten":"output","underputten":"underput","bequeathed":"bequeath","bequethed":"bequeath","bequoth":"bequeath","bequethen":"bequeath","quitted":"quit","reached":"reach","raught":"reach","rought":"reach","retcht":"reach","read ":"read"," readen":"read","forereaden":"foreread","lipreaden":"lipread","misreaden":"misread","proofreaden":"proofread","rereaden":"reread","sight-readen":"sight-read","reaved":"reave","reft":"reave","bereaved":"bereave","bereft":"bereave","rent":"rend","ridden":"rid","ridded":"rid","outridden":"outride","outrid":"outride","overridden":"override","overrid":"override","rung":"ring","risen":"rise","arisen":"arise","uprisen":"uprise","rived":"rive","riven":"rive","sawed":"saw","sawn":"saw","said":"say","forsaid":"forsay","gainsaid":"gainsay","missaid":"missay","naysaid":"naysay","soothsaid":"soothsay","withsaid":"withsay","seen":"see","beseen":"besee","foreseen":"foresee","misseen":"missee","overseen":"oversee","sightseen":"sightsee","underseen":"undersee","sought":"seek","seethed":"seethe","sodden":"seethe","sold":"sell","outsold":"outsell","oversold":"oversell","resold":"resell","undersold":"undersell","upsold":"upsell","sent":"send","missent":"missend","resent":"resend","setten":"set","besetten":"beset","handsetten":"handset","insetten":"inset","missetten":"misset","offsetten":"offset","oversetten":"overset","presetten":"preset","resetten":"reset","upsetten":"upset","withsetten":"withset","sewn":"sew","sewed":"sew","sewen":"sew","handsewn":"handsew","handsewed":"handsew","handsewen":"handsew","oversewn":"oversew","oversewed":"oversew","oversewen":"oversew","shaken":"shake","overshaken":"overshake","shaped":"shape","shapen":"shape","forshaped":"forshape","forshapen":"forshape","misshaped":"misshape","misshapen":"misshape","shaved":"shave","shaven":"shave","shorn":"shear","sheared":"shear","shone":"shine","shined":"shine","beshone":"beshine","beshined":"beshine","shitted":"shit","shat":"shit","shitten":"shit","shited":"shite","shodden":"shoe","shod":"shoe","shoed":"shoe","reshodden":"reshoe","reshod":"reshoe","reshoed":"reshoe","shot":"shoot","shotten":"shoot","misshot":"misshoot","misshotten":"misshoot","overshot":"overshoot","overshotten":"overshoot","reshot":"reshoot","reshotten":"reshoot","undershot":"undershoot","undershotten":"undershoot","shown":"show","showed":"show","shewed":"show","foreshown":"foreshow","foreshowed":"foreshow","foreshewed":"foreshow","reshown":"reshow","reshowed":"reshow","reshewed":"reshow","shrunk":"shrink","shrunken":"shrink","overshrunk":"overshrink","overshrunken":"overshrink","shrived":"shrive","shriven":"shrive","sung":"sing","sungen":"sing","resung":"resing","resungen":"resing","sunk":"sink","sunken":"sink","sat":"sit","sitten":"sit","babysat":"babysit","babysitten":"babysit","housesat":"housesit","housesitten":"housesit","resat":"resit","resitten":"resit","withsat":"withsit","withsitten":"withsit","slain":"slay","slayed":"slay","slept":"sleep","overslept":"oversleep","underslept":"undersleep","slid":"slide","slidden":"slide","backslid":"backslide","backslidden":"backslide","overslid":"overslide","overslidden":"overslide","slung":"sling","slunk":"slink","slinked":"slink","slank":"slink","slipped":"slip","slipt":"slip","overslipped":"overslip","overslipt":"overslip","slitten":"slit","smelled":"smell","smelt":"smell","smitten":"smite","smitted":"smite","sneaked":"sneak","snuck":"sneak","snucked":"sneak","sown":"sow","sowed":"sow","spoken":"speak","spoke":"speak","bespoken":"bespeak","bespoke":"bespeak","forespoken":"forespeak","forespoke":"forespeak","forspoken":"forspeak","forspoke":"forspeak","misspoken":"misspeak","misspoke":"misspeak","sped":"speed","speeded":"speed","spelled":"spell","spelt":"spell","misspelled":"misspell","misspelt":"misspell","spent":"spend","forspent":"forspend","misspent":"misspend","outspent":"outspend","overspent":"overspend","spilled":"spill","spilt":"spill","overspilled":"overspill","overspilt":"overspill","spun":"spin","outspun":"outspin","spat":"spit","spoiled":"spoil","spoilt":"spoil","spreaded":"spread","bespreaded":"bespread","sprung":"spring","sprang":"spring","handsprung":"handspring","handsprang":"handspring","stood":"stand","standen":"stand","forstood":"forstand","forstanden":"forstand","misunderstood":"misunderstand","misunderstanden":"misunderstand","overstood":"overstand","overstanden":"overstand","understood":"understand","understanden":"understand","upstood":"upstand","upstanden":"upstand","withstood":"withstand","withstanden":"withstand","starved":"starve","storven":"starve","stove":"stave","staved":"stave","stoven":"stave","stayed":"stay","staid":"stay","stolen":"steal","stuck":"stick","sticked":"stick","stung":"sting","stunk":"stink","stretched":"stretch","straught":"stretch","straight":"stretch","strewn":"strew","strewed":"strew","bestrewn":"bestrew","bestrewed":"bestrew","overstrewn":"overstrew","overstrewed":"overstrew","stridden":"stride","strode":"stride","strid":"stride","stridded":"stride","bestridden":"bestride","bestrode":"bestride","bestrid":"bestride","bestridded":"bestride","outstridden":"outstride","outstrode":"outstride","outstrid":"outstride","outstridded":"outstride","overstridden":"overstride","overstrode":"overstride","overstrid":"overstride","overstridded":"overstride","struck":"strike","stricken":"strike","overstruck":"overstrike","overstricken":"overstrike","strung":"string","stringed":"string","hamstrung":"hamstring","hamstringed":"hamstring","overstrung":"overstring","overstringed":"overstring","stripped":"strip","stript":"strip","striven":"strive","strived":"strive","outstriven":"outstrive","overstriven":"overstrive","sworn":"swear","forsworn":"forswear","outsworn":"outswear","sweated":"sweat","swept":"sweep","sweeped":"sweep","upswept":"upsweep","upsweeped":"upsweep","swollen":"swell","swelled":"swell","upswollen":"upswell","upswelled":"upswell","swelted":"swelt","swolten":"swelt","swum":"swim","outswum":"outswim","swung":"swing","swungen":"swing","overswung":"overswing","overswungen":"overswing","swunk":"swink","swunken":"swink","swonken":"swink","swinkt":"swink","swinked":"swink","forswunk":"forswink","forswunken":"forswink","toswunk":"toswink","toswunken":"toswink","taken":"take","betaken":"betake","intaken":"intake","mistaken":"mistake","overtaken":"overtake","partaken":"partake","retaken":"retake","undertaken":"undertake","uptaken":"uptake","withtaken":"withtake","taught":"teach","teached":"teach","torn":"tear","uptorn":"uptear","teed":"tee","town":"tee","beteed":"betee","betown":"betee","forteed":"fortee","fortown":"fortee","told":"tell","telled":"tell","foretold":"foretell","foretelled":"foretell","forthtold":"forthtell","mistold":"mistell","outtold":"outtell","outtelled":"outtell","retold":"retell","retelled":"retell","thought":"think","thinked":"think","outthought":"outthink","outthinked":"outthink","rethought":"rethink","rethinked":"rethink","thriven":"thrive","thrived":"thrive","thrown":"throw","throwed":"throw","misthrown":"misthrow","misthrowed":"misthrow","outthrown":"outthrow","outthrowed":"outthrow","overthrown":"overthrow","overthrowed":"overthrow","underthrown":"underthrow","underthrowed":"underthrow","upthrown":"upthrow","upthrowed":"upthrow","thrusted":"thrust","outthrusted":"outthrust","trodden":"tread","trod":"tread","treaded":"tread","retrodden":"retread","retrod":"retread","retreaded":"retread","vexed":"vex","vext":"vex","woken":"wake","waked":"wake","awoken":"awake","awaked":"awake","waxed":"wax","waxen":"wax","weared":"wear","worn":"wear","forweared":"forwear","forworn":"forwear","outweared":"outwear","outworn":"outwear","overweared":"overwear","overworn":"overwear","woven":"weave","interwoven":"interweave","unwoven":"unweave","wedded":"wed","miswedded":"miswed","rewedded":"rewed","wept":"weep","weeped":"weep","bewept":"beweep","beweeped":"beweep","wended":"wend","went":"wend","wetted":"wet","overwetted":"overwet","won":"win","wound":"wind","rewound":"rewind","unwound":"unwind","worked":"work","wrought":"work","overworked":"overwork","overwrought":"overwork","worthed":"worth","worthen":"worth","wreaked":"wreak","wreaken":"wreak","wroken":"wreak","wrung":"wring","wringed":"wring","written":"write","writ":"write","cowritten":"cowrite","ghostwritten":"ghostwrite","ghostwrit":"ghostwrite","handwritten":"handwrite","handwrit":"handwrite","miswritten":"miswrite","miswrit":"miswrite","overwritten":"overwrite","overwrit":"overwrite","rewritten":"rewrite","rewrit":"rewrite","underwritten":"underwrite","underwrit":"underwrite","writhed":"writhe","writhen":"writhe","zinced":"zinc","zinked":"zinc","zincked":"zinc"]
