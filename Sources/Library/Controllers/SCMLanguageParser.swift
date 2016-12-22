//
//  SCMLanguageParser.swift
//  the-narrator
//
//  Created by Chris Martin on 11/22/16.
//
//

//import Foundation
//
//struct Word {
//    
//    enum LexicalToken: String {
//        case verb = "Verb"
//        case noun = "Noun"
//        case adjective = "Adjective"
//        case adverb = "Adverb"
//        case pronoun = "Pronoun"
//        case determiner = "Determiner"
//        case particle = "Particle"
//        case preposition = "Preposition"
//        case number = "Number"
//        case conjunction = "Conjunction"
//        case interjection = "Interjection"
//        case classifier = "Classifier"
//        case idiom = "Idiom"
//        case otherWord = "OtherWord"
//    }
//    
//    var original: String
//    var lemma: String
//    var lexicalToken: LexicalToken
//    
//    init(original: String, lemma: String, lexicalToken: String) {
//        self.original = original
//        self.lemma = lemma
//        self.lexicalToken = LexicalToken(rawValue: lexicalToken)!
//    }
//    
//}
//
//class SCMLanguageParser {
//    
//    var schemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
//    var options = NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.joinNames.rawValue | NSLinguisticTagger.Options.omitPunctuation.rawValue
//
//    func getTags(from string: String) -> [Word] {
//        
//        // Create the tagger
//        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(NSLinguisticTagger.Options.omitWhitespace.rawValue))
//        
//        // Set the string
//        tagger.string = string
//        
//        // Identify range
//        let range = NSRange(location: 0, length: string.utf16.count)
//        
//        // Calculate lexical and lemma tags
//        var ranges: NSArray?
//        let lexicalTags = tagger.tags(in: range, scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: NSLinguisticTagger.Options(rawValue: options), tokenRanges: nil)
//        let lemmaTags = tagger.tags(in: range, scheme: NSLinguisticTagSchemeLemma, options: NSLinguisticTagger.Options(rawValue: options), tokenRanges: &ranges)
//        
//        var tags = [Word]()
//        
//        // Filter out base words
//        let bases = ranges!.flatMap { (item) -> String in
//            let range = item as! NSRange
//            let str = string as NSString
//            return str.substring(with: range)
//        }
//        
//        // Construct Word objects
//        for index in bases.indices {
//            let base = bases[index].lowercased()
//            let lemma = lemmaTags[index]
//            let lexical = lexicalTags[index]
//            let word = Word(original: base, lemma: lemma, lexicalToken: lexical)
//            
//            tags.append(word)
//        }
//        
//        return tags
//    }
//}
