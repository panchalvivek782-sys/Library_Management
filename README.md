### Entity Relationship Specifications

#### 1. `Authors` Table
Stores unique author identifiers and demographic data.
* `author_id` (INT, Primary Key, Auto Increment): Unique identifier for each author.
* `name` (VARCHAR(255), Not Null): Full name of the author.
* `email` (VARCHAR(255)): Professional email address.

#### 2. `Books` Table
Maintains cataloged literary inventory records.
* `book_id` (INT, Primary Key, Auto Increment): Unique catalog identifier.
* `title` (VARCHAR(255), Not Null): Book title.
* `author_id` (INT, Foreign Key): Maps back to `Authors(author_id)` via a one-to-many relationship.
* `category` (VARCHAR(100)): Standardized genre classification (e.g., 'Science', 'Fiction').
* `isbn` (VARCHAR(20)): International Standard Book Number.
* `published_date` (DATE): Global release date.
* `price` (DECIMAL(10, 2)): Purchase price valuation.
* `available_copies` (INT): Current stock count safely sitting on library shelves.

#### 3. `Members` Table
Manages registered library accounts.
* `member_id` (INT, Primary Key, Auto Increment): Unique member account index.
* `name` (VARCHAR(255), Not Null): Full legal name.
* `email` (VARCHAR(255)): Contact email address.
* `phone_number` (VARCHAR(20)): Contact mobile/telephone string.
* `membership_date` (DATE): Account creation date.

#### 4. `Transactions` Table
Linchpin entity mapping ledger entries between members and books.
* `transaction_id` (INT, Primary Key, Auto Increment): Unique transaction receipt ID.
* `member_id` (INT, Foreign Key): Relates back to `Members(member_id)`.
* `book_id` (INT, Foreign Key): Relates back to `Books(book_id)`.
* `borrow_date` (DATE): The day an item left the library.
* `return_date` (DATE, Nullable): Date the item was officially logged back into the shelves.
* `fine_amount` (DECIMAL(10, 2)): Monetary fine calculated automatically or manually on late returns.

---

## Core SQL Implementation Breakdown

### 1. Advanced Window Operations
* **Borrow Tracking Engine**: Leverages analytical functions (`DENSE_RANK()`) to evaluate exactly which titles see maximum library circulation cycles.
* **Rolling Demand Trends**: Measures moving historical averages across dynamic 90-day (`3 MONTH`) parameters to forecast incoming inventory needs.

### 2. Analytical & Conditional Classifications
* **Membership Status Engine**: Runs conditional execution (`CASE`) to scan activity blocks. Members who haven't borrowed books in the past 6 months dynamically transition to an `Inactive` state.
* **Vintage Cataloging**: Segregates historical assets (`Classic`) from incoming contemporary releases (`New Arrival`) based on chronological parameters.
