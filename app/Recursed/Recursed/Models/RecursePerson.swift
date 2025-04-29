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
            first_name: "Colin",
            last_name: "Rafferty",
            name: "Colin Rafferty",
            name_hl: "Colin Rafferty",
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

            before_rc_hl: "30+ years writing all sorts of software for various companies. Past 6 years writing firmware for Lyft's bikes & scooters (e.g. the white citibike).",
            during_rc_hl: "I want to teach myself modern Swift and write a Bluesky iPad app that I'd want to use. With my experience working on the Facebook iPhone app...",
            email: "colin@example.com",
            image_path: "https://i.imgflip.com/2/110hll.jpg",
            pronouns: "he/him",
            unformatted_phone_number: "+17185551212",
            zoom_url: "https://us04web.zoom.us/j/2517163895?pwd=NGtIOEZQbXRKL3FycFl4a0Evd2NaQT09",
        )
}

extension [RecursePerson] {
    static let fakePeople = [
        RecursePerson.fakePerson,

        RecursePerson(
            id: 6721,
            first_name: "Bruce",
            last_name: "Hill",
            name: "Bruce Hill",
            name_hl: "Bruce Hill",
            slug: "6721-bruce-hill",
            stints: [],
            image_path: "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTEzMzQsInB1ciI6ImJsb2JfaWQifX0=--c4bdf9bec23741e8f4395cba1e41daf83d7ff103/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/bruce-face.jpg",
        ),
        RecursePerson(
            id: 6719,
            first_name: "Michael",
            last_name: "Rees",
            name: "Michael Rees",
            name_hl: "Michael Rees",
            slug: "6719-michael-rees",
            stints: [],
            image_path: "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTEzNDgsInB1ciI6ImJsb2JfaWQifX0=--1ef7d97cacc1d92fb2d6352fe5b8b51c0ef89feb/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/mrees-at-organ.jpeg",
        ),
        RecursePerson(
            id: 6716,
            first_name: "Omar",
            last_name: "Hammami",
            name: "Omar Hammami",
            name_hl: "Omar Hammami",
            slug: "6716-omar-hammami",
            stints: [],
            image_path: "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTEzMDYsInB1ciI6ImJsb2JfaWQifX0=--8e0dd2bfdf41187c4df18b1261b7dd760674917e/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/IMG_4706.jpeg",
        ),
        RecursePerson(
            id: 6715,
            first_name: "Presley",
            last_name: "Graham",
            name: "Presley Graham",
            name_hl: "Presley Graham",
            slug: "6715-presley-graham",
            stints: [],
            // image_path: "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTEzMjksInB1ciI6ImJsb2JfaWQifX0=--b2819b99f837d16bb4068f8acae702b5cf19a64f/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/anthropic_profile_cropped.jpg",
        ),
        RecursePerson(
            id: 6711,
            first_name: "Timothy",
            last_name: "Harding",
            name: "Timothy Jonas Harding",
            name_hl: "Timothy Jonas Harding",
            slug: "6711-timothy-jonas-harding",
            stints: [],
            image_path: "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTEzNzEsInB1ciI6ImJsb2JfaWQifX0=--31e45cba7cc0e184d0ba4cf28ff18923a5f58c66/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/20240926_113630%20copy.jpeg",
        ),
    ]
}

extension RecursePerson: Identifiable {}
