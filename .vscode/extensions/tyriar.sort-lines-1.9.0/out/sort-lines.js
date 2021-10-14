"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
function makeSorter(algorithm) {
    return function (lines) {
        return lines.sort(algorithm);
    };
}
function sortActiveSelection(transformers) {
    const textEditor = vscode.window.activeTextEditor;
    if (!textEditor) {
        return undefined;
    }
    const selection = textEditor.selection;
    if (selection.isEmpty && vscode.workspace.getConfiguration('sortLines').get('sortEntireFile') === true) {
        return sortLines(textEditor, 0, textEditor.document.lineCount - 1, transformers);
    }
    if (selection.isSingleLine) {
        return undefined;
    }
    return sortLines(textEditor, selection.start.line, selection.end.line, transformers);
}
function sortLines(textEditor, startLine, endLine, transformers) {
    let lines = [];
    for (let i = startLine; i <= endLine; i++) {
        lines.push(textEditor.document.lineAt(i).text);
    }
    // Remove blank lines in selection
    if (vscode.workspace.getConfiguration('sortLines').get('filterBlankLines') === true) {
        removeBlanks(lines);
    }
    lines = transformers.reduce((currentLines, transform) => transform(currentLines), lines);
    return textEditor.edit(editBuilder => {
        const range = new vscode.Range(startLine, 0, endLine, textEditor.document.lineAt(endLine).text.length);
        editBuilder.replace(range, lines.join('\n'));
    });
}
function removeDuplicates(lines) {
    return Array.from(new Set(lines));
}
function removeBlanks(lines) {
    for (let i = 0; i < lines.length; ++i) {
        if (lines[i].trim() === '') {
            lines.splice(i, 1);
            i--;
        }
    }
}
function reverseCompare(a, b) {
    if (a === b) {
        return 0;
    }
    return a < b ? 1 : -1;
}
function caseInsensitiveCompare(a, b) {
    return a.localeCompare(b, undefined, { sensitivity: 'base' });
}
function lineLengthCompare(a, b) {
    // Use Array.from so that multi-char characters count as 1 each
    const aLength = Array.from(a).length;
    const bLength = Array.from(b).length;
    if (aLength === bLength) {
        return 0;
    }
    return aLength > bLength ? 1 : -1;
}
function lineLengthReverseCompare(a, b) {
    return lineLengthCompare(a, b) * -1;
}
function variableLengthCompare(a, b) {
    return lineLengthCompare(getVariableCharacters(a), getVariableCharacters(b));
}
function variableLengthReverseCompare(a, b) {
    return variableLengthCompare(a, b) * -1;
}
let intlCollator;
function naturalCompare(a, b) {
    if (!intlCollator) {
        intlCollator = new Intl.Collator(undefined, { numeric: true });
    }
    return intlCollator.compare(a, b);
}
function getVariableCharacters(line) {
    const match = line.match(/(.*)=/);
    if (!match) {
        return line;
    }
    const last = match.pop();
    if (!last) {
        return line;
    }
    return last;
}
function shuffleSorter(lines) {
    for (let i = lines.length - 1; i > 0; i--) {
        const rand = Math.floor(Math.random() * (i + 1));
        [lines[i], lines[rand]] = [lines[rand], lines[i]];
    }
    return lines;
}
const transformerSequences = {
    sortNormal: [makeSorter()],
    sortUnique: [makeSorter(), removeDuplicates],
    sortReverse: [makeSorter(reverseCompare)],
    sortCaseInsensitive: [makeSorter(caseInsensitiveCompare)],
    sortCaseInsensitiveUnique: [makeSorter(caseInsensitiveCompare), removeDuplicates],
    sortLineLength: [makeSorter(lineLengthCompare)],
    sortLineLengthReverse: [makeSorter(lineLengthReverseCompare)],
    sortVariableLength: [makeSorter(variableLengthCompare)],
    sortVariableLengthReverse: [makeSorter(variableLengthReverseCompare)],
    sortNatural: [makeSorter(naturalCompare)],
    sortShuffle: [shuffleSorter],
    removeDuplicateLines: [removeDuplicates]
};
exports.sortNormal = () => sortActiveSelection(transformerSequences.sortNormal);
exports.sortUnique = () => sortActiveSelection(transformerSequences.sortUnique);
exports.sortReverse = () => sortActiveSelection(transformerSequences.sortReverse);
exports.sortCaseInsensitive = () => sortActiveSelection(transformerSequences.sortCaseInsensitive);
exports.sortCaseInsensitiveUnique = () => sortActiveSelection(transformerSequences.sortCaseInsensitiveUnique);
exports.sortLineLength = () => sortActiveSelection(transformerSequences.sortLineLength);
exports.sortLineLengthReverse = () => sortActiveSelection(transformerSequences.sortLineLengthReverse);
exports.sortVariableLength = () => sortActiveSelection(transformerSequences.sortVariableLength);
exports.sortVariableLengthReverse = () => sortActiveSelection(transformerSequences.sortVariableLengthReverse);
exports.sortNatural = () => sortActiveSelection(transformerSequences.sortNatural);
exports.sortShuffle = () => sortActiveSelection(transformerSequences.sortShuffle);
exports.removeDuplicateLines = () => sortActiveSelection(transformerSequences.removeDuplicateLines);
//# sourceMappingURL=sort-lines.js.map