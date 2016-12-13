import Foundation

struct Word {
    var original: String
    var lemma: String
    var lexicalRepresentation: String
}

class SCMLanguageParser {
    
    var schemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
    var options = NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.joinNames.rawValue | NSLinguisticTagger.Options.omitPunctuation.rawValue
    
    func getTags(from string: String) -> [Word] {
        
        // Create the tagger
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(NSLinguisticTagger.Options.omitWhitespace.rawValue))
        
        // Set the string
        tagger.string = string
        
        // Identify range
        let range = NSRange(location: 0, length: string.utf16.count)
        
        // Calculate lexical and lemma tags
        var ranges: NSArray?
        let lexicalTags = tagger.tags(in: range, scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: NSLinguisticTagger.Options(rawValue: options), tokenRanges: nil)
        let lemmaTags = tagger.tags(in: range, scheme: NSLinguisticTagSchemeLemma, options: NSLinguisticTagger.Options(rawValue: options), tokenRanges: &ranges)
        
        var tags = [Word]()
        
        // Filter out base words
        let bases = ranges!.flatMap { (item) -> String in
            let range = item as! NSRange
            let str = string as NSString
            return str.substring(with: range)
        }
        
        // Construct Word objects
        for index in bases.indices {
            let base = bases[index].lowercased()
            let lemma = lemmaTags[index]
            let lexical = lexicalTags[index]
            let word = Word(original: base, lemma: lemma, lexicalRepresentation: lexical)
            
            tags.append(word)
        }
        
        return tags
    }
}

let thing = SCMLanguageParser()
let string = "Pick up apple."

let tags = thing.getTags(from: string)

dump(tags)