#!/usr/bin/env python3
"""Build an unsigned native Shortcut; sign/import it with Apple's shortcuts CLI."""
import plistlib
import sys
from uuid import NAMESPACE_URL, uuid5


def uid(name):
    return str(uuid5(NAMESPACE_URL, "local.mubuntu.shazam.spotify/" + name)).upper()


def output(name, property_name=None):
    value = {"Type": "ActionOutput", "OutputUUID": uid(name), "OutputName": name}
    if property_name:
        value["Aggrandizements"] = [
            {"Type": "WFPropertyVariableAggrandizement", "PropertyName": property_name}
        ]
    return value


def attachment(name):
    return {"Value": output(name), "WFSerializationType": "WFTextTokenAttachment"}


def text(template, *values):
    positions = [i for i, char in enumerate(template) if char == "\ufffc"]
    assert len(positions) == len(values)
    return {
        "Value": {
            "string": template,
            "attachmentsByRange": {f"{{{i}, 1}}": v for i, v in zip(positions, values)},
        },
        "WFSerializationType": "WFTextTokenString",
    }


def action(kind, **parameters):
    return {"WFWorkflowActionIdentifier": "is.workflow.actions." + kind,
            "WFWorkflowActionParameters": parameters}


condition = {"GroupingIdentifier": uid("recognized")}
menu = {"GroupingIdentifier": uid("choices")}
# Text, URL Encode, and URL actions failed as missing on this Mac (27.0.1).
# Inline magic variables let Open URLs handle the URI without those actions.
actions = [
    action("shazamMedia", UUID=uid("Song"), WFShazamMediaActionShowWhenRun=True,
           WFShazamMediaActionErrorIfNotRecognized=False),
    action("conditional", **condition, WFControlFlowMode=0, WFCondition=100,
           WFInput={"Type": "Variable", "Variable": attachment("Song")}),
    action("choosefrommenu", **menu, WFControlFlowMode=0,
           WFMenuPrompt=text("\ufffc by \ufffc", output("Song", "Title"), output("Song", "Artist")),
           WFMenuItems=["Search in Spotify", "Copy song and artist"]),
    action("choosefrommenu", **menu, WFControlFlowMode=1,
           WFMenuItemTitle="Search in Spotify"),
    action("openurl", WFInput=text(
        "spotify:search:\ufffc \ufffc", output("Song", "Title"), output("Song", "Artist"))),
    action("choosefrommenu", **menu, WFControlFlowMode=1,
           WFMenuItemTitle="Copy song and artist"),
    action("setclipboard", WFInput=text(
        "\ufffc by \ufffc", output("Song", "Title"), output("Song", "Artist"))),
    action("choosefrommenu", **menu, WFControlFlowMode=2),
    action("conditional", **condition, WFControlFlowMode=1),
    action("alert", WFAlertActionTitle="No song recognized",
           WFAlertActionMessage="Play the song and run shazam again.",
           WFAlertActionCancelButtonShown=False),
    action("conditional", **condition, WFControlFlowMode=2),
]
shortcut = {
    "WFWorkflowName": "Shazam to Spotify",
    "WFWorkflowClientVersion": "4000",
    "WFWorkflowMinimumClientVersion": 900,
    "WFWorkflowIcon": {"WFWorkflowIconStartColor": 4251333119,
                       "WFWorkflowIconGlyphNumber": 61462},
    "WFWorkflowTypes": [],
    "WFWorkflowInputContentItemClasses": [],
    "WFWorkflowActions": actions,
}

# Validate nested native control flow and all action-output references.
stack, seen = [], set()
for item in actions:
    params = item["WFWorkflowActionParameters"]
    mode = params.get("WFControlFlowMode")
    if mode == 0:
        stack.append(params["GroupingIdentifier"])
    elif mode in (1, 2):
        assert stack[-1] == params["GroupingIdentifier"]
        if mode == 2:
            stack.pop()
    def check_refs(value):
        if isinstance(value, dict):
            if "OutputUUID" in value:
                assert value["OutputUUID"] in seen
            for child in value.values():
                check_refs(child)
        elif isinstance(value, list):
            for child in value:
                check_refs(child)
    check_refs(params)
    if "UUID" in params:
        seen.add(params["UUID"])
assert not stack
assert "apple music" not in str(shortcut).lower()
assert not {item["WFWorkflowActionIdentifier"] for item in actions} & {
    "is.workflow.actions.gettext", "is.workflow.actions.urlencode", "is.workflow.actions.url"
}
search = next(item for item in actions if item["WFWorkflowActionIdentifier"] == "is.workflow.actions.openurl")
search_text = search["WFWorkflowActionParameters"]["WFInput"]["Value"]
assert search_text["string"] == "spotify:search:\ufffc \ufffc"
assert [value["Aggrandizements"][0]["PropertyName"]
        for value in search_text["attachmentsByRange"].values()] == ["Title", "Artist"]

if __name__ == "__main__":
    with open(sys.argv[1], "wb") as destination:
        plistlib.dump(shortcut, destination, fmt=plistlib.FMT_BINARY)
