//
//  GoogleAnaliticConst.swift
//  Flirtbox
//
//  Created by Azamat Valitov on 05.02.16.
//  Copyright © 2016 flirtbox. All rights reserved.
//

import Foundation

struct GoogleAnalitics {
    static func send(screenName: String, category: String? = nil, action: String? = nil, label: String? = nil, value: NSNumber? = nil) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screenName)
        let dict = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build()
        tracker.send(dict as [NSObject : AnyObject])
    }
    struct Splash{
        static let ScreenName = "Splash Activity"
        static let Category = "Action"
    }
    struct Login {
        static let ScreenName = "Login Activity"
        static let Category = "Action"
    }
    struct MainScreen {
        static let ScreenName = "Main Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        static let TODAYJOBBUTTON = "Main - Today's Jobs Button"
        static let MAPTODAYSJOBBUTTON = "Main - Map Today's Jobs Button"
        static let PROFILEBUTTON = "Main - Profile Button"
        static let RESUMEBUTTON = "Main - Resume Button"
        static let SEARCHNEWJOBSBUTTON = "Main - Search New Jobs Button"
        static let SEARCHPREVIOUSJOBSBUTTON = "Main - Search Previous Jobs Button"
        static let MESSAGESBUTTON = "Main - Messages Button"
        static let LOGOUTBUTTON = "Main - Logout Button"
    }
    struct MapTodayJobScreen {
        static let ScreenName = "Map Jobs Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        static let TODAYJOBBUTTON = "Map - Today's Jobs Button"
        static let MAINPAGEBUTTON = "Map - Main Button"
    }
    struct MessageScreen {
        static let ScreenName = "Message Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        static let PROFILEBUTTON = "Message - Profile Button"
        static let MAINPAGEBUTTON = "Message - Main Button"
        static let RESUMEBUTTON = "Message - Resume Button"
    }
    struct PreviousJobsScreen {
        static let ScreenName = "Previous Jobs Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        static let MAINPAGEBUTTON = "Previous - Main Button"
        static let MAPTODAYSJOBBUTTON = "Previous - Map Today's Jobs Button"
        static let PROFILEBUTTON = "Previous - Profile Button"
        static let RESUMEBUTTON = "Previous - Resume Button"
    }
    struct ProfileScreen {
        static let ScreenName = "Message Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        
        static let EDITBUTTON = "Profile - Edit Button"
        static let SAVEBUTTON = "Profile - Save Button"
        static let FACEBOOKSHAREBUTTON = "Profile - Facebook Share Button"
        static let TWITTERSHAREBUTTON = "Profile - Twitter Share Button"
        static let INSTAGRAMSHAREBUTTON = "Profile - Instagram Share"
        
        static let MAINPAGEBUTTON = "Profile - Main Button"
        static let MAPTODAYSJOBBUTTON = "Profile - Map Today's Jobs Button"
        static let PROFILEBUTTON = "Profile - Profile Button"
        static let RESUMEBUTTON = "Profile - Resume Button"
        static let SEARCHNEWJOBSBUTTON = "Profile - Search New Jobs Button"
        static let SEARCHPREVIOUSJOBSBUTTON = "Profile - Search Previous Jobs Button"
        static let TODAYJOBBUTTON = "Profile - Today's Jobs Button"
    }
    struct ResumeScreen {
        static let ScreenName = "Resume Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        
        static let SHAREBUTTON = "Resume - Share Button"
        static let SAVEBUTTON = "Resume - Save Button"
        static let MAINPAGEBUTTON = "Resume - Main Button"
        static let MAPTODAYSJOBBUTTON = "Resume - Map Today's Jobs Button"
        static let PROFILEBUTTON = "Resume - Profile Button"
        static let SEARCHNEWJOBSBUTTON = "Resume - Search New Jobs Button"
        static let SEARCHPREVIOUSJOBSBUTTON = "Resume - Search Previous Jobs Button"
        static let TODAYJOBBUTTON = "Resume - Today's Jobs Button"
        
    }
    
    struct SearchScreen {
        static let ScreenName = "Search Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        
        static let MAINPAGEBUTTON = "Search - Main Button"
        static let SEARCHBUTTON = "Search - Search Button"
        static let MAPTODAYSJOBBUTTON = "Search - Map Today's Jobs Button"
        static let PROFILEBUTTON = "Search - Profile Button"
        static let RESUMEBUTTON = "Search - Resume Button"
        static let SEARCHNEWJOBSBUTTON = "Search - Search New Jobs Button"
        static let SEARCHPREVIOUSJOBSBUTTON = "Search - Search Previous Jobs Button"
        static let TODAYJOBBUTTON = "Search - Today's Jobs Button"
        
    }
    
    struct TodayJobsScreen {
        static let ScreenName = "Today Jobs Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        
        static let MAINPAGEBUTTON = "Today - Main Button"
        static let SEARCHBUTTON = "Today - Search Button"
        static let MAPTODAYSJOBBUTTON = "Today - Map Today's Jobs Button"
        static let PROFILEBUTTON = "Today - Profile Button"
        static let RESUMEBUTTON = "Today - Resume Button"
        
    }
    struct MessageDetailScreen {
        static let ScreenName = "Today Jobs Activity"
        static let Category = "Action"
        static let Action = "Click"
        //label...
        
        static let MAINPAGEBUTTON = "Today - Main Button"
        static let SEARCHBUTTON = "Today - Search Button"
        static let MAPTODAYSJOBBUTTON = "Today - Map Today's Jobs Button"
        static let PROFILEBUTTON = "Today - Profile Button"
        static let RESUMEBUTTON = "Today - Resume Button"
        
    }


}

