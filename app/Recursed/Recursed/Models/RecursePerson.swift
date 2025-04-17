// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct RecursePerson: Decodable {
    var id: Int
    var first_name: String
    var last_name: String
    var name: String
    var name_hl: String
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
    var before_rc_match: String?
    var before_rc_truncated: String?
    var bio_hl: String?
    var bio_match: String?
    var bio_truncated: String?
    var company: RecurseCompany?
    var current_location: RecurseLocation?
    var during_rc_hl: String?
    var during_rc_match: String?
    var during_rc_truncated: String?
    var email: String?
    var email_hl: String?
    var email_match: String?
    var email_truncated: String?
    var employer_info_hl: String?
    var employer_info_match: String?
    var employer_info_truncated: String?
    var employer_role: String?
    var github: String?
    var github_hl: String?
    var github_match: String?
    var github_truncated: String?
    var image_path: String? // "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTExNzQsInB1ciI6ImJsb2JfaWQifX0=--a2dbc1c267a544e65f7f6d8fc99a8c6592d6936c/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/IMG_8365.jpeg",
    var interests_hl: String?
    var interests_match: String?
    var interests_truncated: String?
    var joy_of_computing_username: String?
    var linkedin: String?
    var phone_number: String?
    var phone_number_hl: String?
    var phone_number_match: String?
    var phone_number_truncated: String?
    var pronouns: String?
    var twitter: String?
    var unformatted_phone_number: String?
    var zoom_url: String? // "https://us04web.zoom.us/j/2517163895?pwd=NGtIOEZQbXRKL3FycFl4a0Evd2NaQT09",
    var zulip_intro_hl: String?
    var zulip_intro_match: String?
    var zulip_intro_truncated: String?

    static let fakePerson =
        RecursePerson(
            id: 867_5309,
            first_name: "Tommy",
            last_name: "Tutone",
            name: "Tommy Tutone",
            name_hl: "Tommy Tutone",
            stints: [],
            before_rc_hl: "Singing fun music.",
            email: "tommy@tuto.ne",
            image_path: "https://m.media-amazon.com/images/M/MV5BM2ZkOTNkNTEtNjlmOS00NTdiLTk3NDEtZjAxZGIyZmY3NTdjXkEyXkFqcGdeQXVyMTU3MzMwNQ@@._V1_QL75_UY140_CR24,0,140,140_.jpg",
        )
}

extension RecursePerson: Identifiable {}
