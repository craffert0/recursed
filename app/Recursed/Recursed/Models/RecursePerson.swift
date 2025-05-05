// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct RecursePerson: Decodable {
    var id: Int
    var first_name: String
    var last_name: String
    var name: String
    var name_hl: String
    var slug: String
    var stints: [RecurseStint]
    // var before_rc_rendered: String
    // var bio_rendered: String
    // var during_rc_rendered: String
    // var email_rendered: String
    // var employer_info_rendered: String
    // var github_rendered: String
    // var interests_rendered: String
    // var phone_number_rendered: String
    // var slug: String
    // var zulip_id: Int
    // var zulip_intro_rendered: String

    var before_rc_hl: String?
    var before_rc_match: Bool?
    var before_rc_truncated: String?
    var bio_hl: String?
    var bio_match: Bool?
    var bio_truncated: String?
    var company: RecurseCompany?
    var current_location: RecurseLocation?
    var during_rc_hl: String?
    var during_rc_match: Bool?
    var during_rc_truncated: String?
    var email: String?
    var email_hl: String?
    var email_match: Bool?
    var email_truncated: String?
    var employer_info_hl: String?
    var employer_info_match: Bool?
    var employer_info_truncated: String?
    var employer_role: String?
    var github: String?
    var github_hl: String?
    var github_match: Bool?
    var github_truncated: String?
    var image_path: String? // "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTExNzQsInB1ciI6ImJsb2JfaWQifX0=--a2dbc1c267a544e65f7f6d8fc99a8c6592d6936c/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/IMG_8365.jpeg",
    var interests_hl: String?
    var interests_match: Bool?
    var interests_truncated: String?
    var joy_of_computing_username: String?
    var linkedin: String?
    var phone_number: String?
    var phone_number_hl: String?
    var phone_number_match: Bool?
    var phone_number_truncated: String?
    var pronouns: String?
    var twitter: String?
    var unformatted_phone_number: String?
    var zoom_url: String? // "https://us04web.zoom.us/j/2517163895?pwd=NGtIOEZQbXRKL3FycFl4a0Evd2NaQT09",
    var zulip_intro_hl: String?
    var zulip_intro_match: Bool?
    var zulip_intro_truncated: String?
}

extension RecursePerson {
    static let fakePerson =
        RecursePerson(
            id: 6694,
            first_name: "Groucho",
            last_name: "Marx",
            name: "Groucho Marx",
            name_hl: "Groucho Marx",
            slug: "6694-colin-rafferty",

            stints: [
                RecurseStint(
                    id: 4705,
                    for_half_batch: false,
                    in_progress: true,
                    start_date: "2025-02-17",
                    type: "retreat",

                    end_date: "2025-05-09",
                    batch: RecurseStint.Batch(
                        id: 172,
                        name: "Spring 1, 2025",
                        short_name: "SP1'25",
                        alt_name: "Spring 1 '25"
                    )
                ),
            ],

            before_rc_hl: "Over a dozen years of vaudeville with my brothers, starting as a musical act, but we eventually learned that we were better comedians than signers.",
            during_rc_hl: "Take everything I've learned in vaudeville (and Broadway!) and figure out how to translate that to the movies.",
            email: "groucho@example.com",
            image_path: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Groucho_Marx_-_portrait.jpg/500px-Groucho_Marx_-_portrait.jpg",
            pronouns: "he/him",
            unformatted_phone_number: "+17185551212",
            zoom_url: "https://us04web.zoom.us/invalid",
        )
}

extension [RecursePerson] {
    static let fakePeople = [
        RecursePerson.fakePerson,

        RecursePerson(
            id: 6721,
            first_name: "Karl",
            last_name: "Marx",
            name: "Karl Marx",
            name_hl: "Karl Marx",
            slug: "6721-bruce-hill",
            stints: [],
            image_path: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Karl_Marx_001_%28rotated%29.jpg/250px-Karl_Marx_001_%28rotated%29.jpg",
        ),
        RecursePerson(
            id: 6719,
            first_name: "Chico",
            last_name: "Rees",
            name: "Chico Marx",
            name_hl: "Chico Marx",
            slug: "6719-michael-rees",
            stints: [],
            image_path: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Chico_Marx_-_signed.jpg/250px-Chico_Marx_-_signed.jpg",
        ),
        RecursePerson(
            id: 1234,
            first_name: "Zeppo",
            last_name: "Marx",
            name: "Zeppo Marx",
            name_hl: "Zeppo Marx",
            slug: "6719-michael-rees",
            stints: [],
            image_path: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Zeppo_Marx.jpg/250px-Zeppo_Marx.jpg",
        ),
        RecursePerson(
            id: 6715,
            first_name: "Gummo",
            last_name: "Marx",
            name: "Gummo Marx",
            name_hl: "Gummo Marx",
            slug: "6715-presley-graham",
            stints: [],
        ),
        RecursePerson(
            id: 6716,
            first_name: "Harpo",
            last_name: "Marx",
            name: "Harpo Marx",
            name_hl: "Harpo Marx",
            slug: "6716-omar-hammami",
            stints: [],
            image_path: "https://upload.wikimedia.org/wikipedia/commons/1/1a/Harpo_Marx_playing_the_harp_%28cropped%29.jpeg",
        ),
    ]
}

extension RecursePerson: Identifiable {}
