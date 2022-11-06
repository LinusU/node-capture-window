/**
 * Captures the window with the title `title` of type `bundle`. `bundle` is usually the name of the application, e.g. `Finder`, `Safari`, `Terminal`.
 *
 * @returns path to a png file
 */
declare async function captureWindow (bundle: string, title: string, filePath?: string | null): Promise<string>
export = captureWindow
