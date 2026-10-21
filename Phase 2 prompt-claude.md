Act as an expert frontend engineer and UI/UX designer. I am going to provide you with a User Requirement Specification (URS) for an internal business tool.

Your task is to build a highly polished, fully functional frontend prototype in **Next.js** (App Router, TypeScript, React). Every prototype is built in Next.js, never as a single HTML file (owner's rule, 16/10/2026), so the prototype's components can be carried into the real build instead of being rewritten.

Here are the strict guidelines for the build:
1. WHERE IT LIVES: If the tool belongs to an existing Next.js app, build the prototype as routes and components inside that app, in the tool's own home, rendered in the app's real signed-in shell (its top bar, navigation, design tokens and themes), and compare it against the running app by screenshot. Otherwise create one new Next.js app in ONE canonical folder. Either way, record the path in the URS header.
2. DESIGN SYSTEM: Inside an existing app, use only that app's design tokens, components and table headers; introduce no style of its own. In a new app, use a modern, clean, professional enterprise aesthetic (think Stripe or Vercel dashboard) with consistent spacing and subtle shadows/borders.
3. FUNCTIONALITY: Implement all core functional requirements (FRs) listed in the URS as working React state and interactions, so the UI actually "works" (dynamic calculations, form validations, tab switching, state changes when buttons are clicked).
4. NO BACKEND: The prototype reads and writes only a typed mock data module (for example `mock-data.ts`) behind the same function names the real build will call, so the real implementation replaces the module and nothing else. No database, no external API, no secrets.
5. RESPONSIVENESS: The layout must be fully responsive and look great on standard desktop screens (since this is an internal business tool).
6. MOCK DATA: Include realistic, pre-populated placeholder data so the UI looks alive and usable immediately. All mock data must be obviously fake: no real customer names, rates, or margins.
7. MARK THE MOCKS: Prefix every mock calculation or fake data block with a `// MOCK:` comment, so they can all be found and replaced later.
8. IT MUST RUN: The prototype starts with the app's normal dev command (`pnpm dev` or `npm run dev`), type-checks, and lints clean. Write every file out in full; do not truncate.
9. NO GUESSING: If any requirement is ambiguous or contradictory, stop and list your questions instead of guessing.
10. TRACEABILITY: After the code, list each FR number and the route and component where it is implemented. Flag anything you added that isn't in the URS.

Here is the URS:
[INSERT YOUR COMPLETED URS HERE]
