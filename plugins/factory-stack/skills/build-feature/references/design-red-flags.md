# Design red flags

Screen every candidate shape. A red flag is a reason to revise or reject it.

- **Shallow module.** A large interface that hides little. Callers coordinate several methods for one operation, or options expose internal stages. Prefer a small interface over substantial behavior.
- **Information leakage.** Several modules depend on one internal decision (a representation, policy, or wire format), so a change needs coordinated edits. Parse external data into domain types behind the interface.
- **Temporal decomposition.** Modules split by execution order (load, validate, transform, save) repeat one representation across boundaries. Group by the knowledge each owns.
- **Pass-through method.** A method that forwards the same arguments to another with the same shape. Remove it unless it adds policy or adaptation.
- **Split ownership.** More than one module writes the same state. Give each piece of state one owner.
- **Two ways to do one task.** Agents copy whichever they find first. Keep one, migrate callers, delete the other in the same change.
- **Importable internals.** Callers can import a module's internals and will. Make them unreachable from outside.
- **Hand-synced list.** Two places list the same items. Derive one from the other, or fail the build when they disagree.
