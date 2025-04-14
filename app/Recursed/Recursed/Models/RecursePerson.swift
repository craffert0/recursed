// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

struct RecursePerson: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let name: String
    let name_hl: String
    let email: String?
    let github: String?
    let employer_role: String?
    let twitter: String?
    let pronouns: String?
    let unformatted_phone_number: String?
    let zoom_url: String // "https://us04web.zoom.us/j/2517163895?pwd=NGtIOEZQbXRKL3FycFl4a0Evd2NaQT09",
    let zulip_id: Int
    let linkedin: String?
    let image_path: String? // "https://assets.recurse.com/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MTExNzQsInB1ciI6ImJsb2JfaWQifX0=--a2dbc1c267a544e65f7f6d8fc99a8c6592d6936c/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJwbmciLCJyZXNpemVfdG9fbGltaXQiOlsxNTAsMTUwXX0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--c257f6a9754e757077206289954839be3466cb57/IMG_8365.jpeg",
    let phone_number: String?
    let slug: String
    let joy_of_computing_username: String?
    let bio_rendered: String
    let bio_match: String?
    let bio_hl: String?
    let bio_truncated: String?
    let before_rc_rendered: String
    let before_rc_match: String?
    let before_rc_hl: String?
    let before_rc_truncated: String?
    let during_rc_rendered: String
    let during_rc_match: String?
    let during_rc_hl: String?
    let during_rc_truncated: String?
    let interests_rendered: String
    let interests_match: String?
    let interests_hl: String?
    let interests_truncated: String?
    let zulip_intro_rendered: String
    let zulip_intro_match: String?
    let zulip_intro_hl: String?
    let zulip_intro_truncated: String?
    let employer_info_rendered: String
    let employer_info_match: String?
    let employer_info_hl: String?
    let employer_info_truncated: String?
    let github_rendered: String
    let github_match: String?
    let github_hl: String?
    let github_truncated: String?
    let phone_number_rendered: String
    let phone_number_match: String?
    let phone_number_hl: String?
    let phone_number_truncated: String?
    let email_rendered: String
    let email_match: String?
    let email_hl: String?
    let email_truncated: String?
    let current_location: RecurseLocation
    let stints: [RecurseStint]
    let company: RecurseCompany
}
