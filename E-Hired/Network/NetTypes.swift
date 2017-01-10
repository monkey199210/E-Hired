//
//  NetTypes.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/9/16.
//  Copyright © 2016 ku. All rights reserved.
//

import Foundation
import Genome
struct EHUser : BasicMappable {
    private(set) var username: String = ""
    private(set) var facebookid: String?
    private(set) var profileMainImage: String?
    private(set) var longitude: String?
    private(set) var latitude: String?
    private(set) var description: String = ""
    private(set) var base: String = "0"
    private(set) var fly: String = "0"
    private(set) var both: String = "0"
    private(set) var lbasing: String = "0"
    private(set) var whips: String = "0"
    private(set) var pops: String = "0"
    private(set) var hand: String = "0"
    private(set) var acrotype: String = "0"
    private(set) var rate: String = "0"
    private(set) var imgpath1: String?
    private(set) var imgpath2: String?
    private(set) var imgpath3: String?
    private(set) var ready: String = "0"
    private(set) var hide: String = "0"
    private(set) var phoneNumber: String = ""

    mutating func sequence(map: Map) throws {
        
        try username <~ map["name"]
        try facebookid <~ map["facebookid"]
        try profileMainImage <~ map["imgUri"]
        try phoneNumber <~ map["phoneNumber"]
        try longitude <~ map["longitude"]
        try latitude <~ map["latitude"]
        try description <~ map["des"]
        try base <~ map["base"]
        try fly <~ map["fly"]
        try both <~ map["both"]
        try lbasing <~ map["lbasing"]
        try whips <~ map["whips"]
        try pops <~ map["pops"]
        try hand <~ map["hand"]
        try acrotype <~ map["acrotype"]
        try rate <~ map["rate"]
        try imgpath1 <~ map["imgpath1"]
        try imgpath2 <~ map["imgpath2"]
        try imgpath3 <~ map["imgpath3"]
        try ready <~ map["ready"]
        try hide <~ map["hide"]
    }
}
struct EHJobs : BasicMappable {
    struct Detail : BasicMappable {
        private(set) var job_title: String = ""
        private(set) var job_site: String = ""
        private(set) var job_site_id: String = ""
        private(set) var job_link: String = ""
        private(set) var job_snippet: String = ""
        private(set) var job_company: String = ""
        private(set) var location_found: String = ""
        private(set) var location_name: String = ""
        private(set) var location_address: String = ""
        private(set) var location_latitude: String = ""
        private(set) var location_longitude: String = ""
        mutating func sequence(map: Map) throws {
            try job_title <~ map["job_title"]
            try job_site <~ map["job_site"]
            try job_site_id <~ map["job_site_id"]
            try job_link <~ map["job_link"]
            try job_snippet <~ map["job_snippet"]
            try job_company <~ map["job_company"]
            try location_found <~ map["location_found"]
            try location_name <~ map["location_name"]
            try location_address <~ map["location_address"]
            try location_latitude <~ map["location_latitude"]
            try location_longitude <~ map["location_longitude"]
        }
    }
    private(set) var detail: [Detail] = []
    private(set) var status: String = ""
    private(set) var error: String = ""
    
    mutating func sequence(map: Map) throws {
        try status <~ map["status"]
        try error <~ map["error"]
        try detail <~ map["results"]
    }
}
struct EHProfile : BasicMappable {
    struct Detail : BasicMappable {
        private(set) var user_last_name: String = ""
        private(set) var user_first_name: String = ""
        private(set) var user_email: String = ""
        private(set) var user_zip_code: String?
        private(set) var profile_resume_url: String = ""
        private(set) var profile_picture: String?
        private(set) var profile_objective: String = ""
        private(set) var profile_industry: String?
        private(set) var profile_salary: String = ""
        private(set) var profile_availability: String = ""
        private(set) var profile_education: String = ""
        private(set) var profile_skills: Array<String>?
        mutating func sequence(map: Map) throws {
            try user_last_name <~ map["user_last_name"]
            try user_first_name <~ map["user_first_name"]
            try user_email <~ map["user_email"]
            try user_zip_code <~ map["user_zip_code"]
            try profile_resume_url <~ map["profile_resume_url"]
            try profile_picture <~ map["profile_picture"]
            try profile_objective <~ map["profile_objective"]
            try profile_industry <~ map["profile_industry"]
            try profile_salary <~ map["profile_salary"]
            try profile_availability <~ map["profile_availability"]
            try profile_education <~ map["profile_education"]

            try profile_skills <~ map["profile_skills"]

            
        }
    }
    private(set) var detail: Detail!
    private(set) var status: String!
    private(set) var error: String!
    
    mutating func sequence(map: Map) throws {
        try status <~ map["status"]
        try error <~ map["error"]
        try detail <~ map["result"]
    }
}
struct EHMessage : BasicMappable {
    struct Detail : BasicMappable {
        private(set) var message_id: String = ""
        private(set) var message_from: String = ""
        private(set) var message_subject: String = ""
        private(set) var message_body: String?
        private(set) var message_priority: String?
        private(set) var message_sent: String?
        private(set) var message_icon: String = ""
        private(set) var message_opened: String = ""
        private(set) var message_date: String = ""
        
        mutating func sequence(map: Map) throws {
            try message_id <~ map["message_id"]
            try message_from <~ map["message_from"]
            try message_subject <~ map["message_subject"]
            try message_body <~ map["message_body"]
            try message_priority <~ map["message_priority"]
            try message_sent <~ map["message_sent"]
            try message_icon <~ map["message_icon"]
            try message_opened <~ map["message_opened"]
            try message_date <~ map["message_date"]
        }
    }
    private(set) var detail: [Detail]!
    private(set) var status: String!
    private(set) var error: String!
    
    mutating func sequence(map: Map) throws {
        try status <~ map["status"]
        try error <~ map["error"]
        try detail <~ map["results"]
    }
}
struct EHResult : BasicMappable {
    private(set) var status: String = ""
    private(set) var error: String = ""
    private(set) var result: String = ""
    mutating func sequence(map: Map) throws {
        try status <~ map["status"]
        try error <~ map["error"]
        try result <~ map["result"]
    }
}
struct EHAPIKey : BasicMappable {
    private(set) var status: String = ""
    private(set) var error: String = ""
    private(set) var api_key: String = ""
    mutating func sequence(map: Map) throws {
        try status <~ map["status"]
        try error <~ map["error"]
        try api_key <~ map["api-key"]
    }
}