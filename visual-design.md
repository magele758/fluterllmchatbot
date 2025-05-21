# AI Assistant Visual Design Specification

## Design System

### Colors
- **Primary**: #4A6FE6 (Blue)
- **Secondary**: #8C61FF (Purple)
- **Accent**: #42E8A3 (Mint Green)
- **Light Theme Background**: #F8F9FC (Light Gray)
- **Dark Theme Background**: #1A1C2D (Dark Blue)
- **User Message Bubble**: #4A6FE6 (Primary)
- **AI Message Bubble (Light)**: #E9ECFC (Light Blue)
- **AI Message Bubble (Dark)**: #333649 (Dark Gray-Blue)

### Typography
- **Font Family**: Roboto
- **Headings**:
  - H1: 32px, Bold
  - H2: 24px, Bold
  - H3: 20px, Bold
- **Body Text**:
  - Regular: 16px
  - Small: 14px
  - Caption: 12px

### Spacing
- 4px, 8px, 16px, 24px, 32px, 48px, 64px

### Corners
- **Small**: 8px
- **Medium**: 12px
- **Large**: 20px

### Shadows
- **Small**: 0px 2px 4px rgba(0, 0, 0, 0.1)
- **Medium**: 0px 4px 8px rgba(0, 0, 0, 0.1)
- **Large**: 0px 8px 16px rgba(0, 0, 0, 0.1)

## Mobile Design

### Splash Screen
- App logo centered (rounded square with chat icon)
- App name below logo
- Loading indicator at bottom
- Full screen in primary brand color with white text

### Login Screen
- WeChat login button (green)
- App logo at top
- Welcome text
- Simple, clean layout with ample white space
- Background in light theme color

### Main Chat Screen
- Chat bubbles for messages
- User messages right-aligned in primary color
- AI messages left-aligned in light blue
- Content type selector at top (Text, Image, Video, Audio)
- Input field at bottom with send button
- Deep thinking toggle in header
- Settings button in top-right
- Floating action button to start new conversation

### Settings Screen
- Sections clearly separated
- Toggle switches for features
- AI model configuration cards
- Theme selection with visual indicators
- Clean, organized layout with card-based sections

### Model Configuration Screen
- Form layout with clear sections
- Input fields with validation
- Capability selection using chips
- Save/Update button prominently displayed
- Delete option (when editing) with confirmation

## Desktop Design

### Layout Differences
- Two-panel layout for chat screen
  - Left: Conversation list/history
  - Right: Current conversation
- Wider input field
- More spacious layout
- Larger preview for generated media
- Expanded settings screen with side navigation

### Responsive Behavior
- Fluid layout that adapts to screen size
- Breakpoints at 600px, 960px, and 1280px
- Mobile-first design that enhances at larger sizes
- Maintains consistent visual language across sizes

## Component Details

### Chat Bubble
- Rounded corners (more rounded on non-adjacent side)
- Padding: 12px
- Max width: 75% of screen width
- Timestamp below in small text
- Special badge for "Deep Thinking" responses
- Media preview with rounded corners

### Content Type Selector
- Horizontal row of buttons
- Icon + text for each type
- Selected state uses primary color
- Unselected state uses muted text color
- Subtle hover effect

### Input Area
- Text field with rounded corners
- Attachment button for non-text content
- Send button with primary color
- Dynamic height based on content
- Media preview above when selected

### Settings Toggle
- Standard platform switch component
- Clear label and description
- Primary color when active

### Model Selection
- Card-based design with selection indicator
- Model name and provider prominently displayed
- Capability tags using chips
- Selection uses border in primary color

## User Flow Animation Guidelines
- Smooth transitions between screens (300ms)
- Fade transitions for content loading
- Subtle scale animation for buttons
- Message appear animation (fade + slide)
- Loading indicators with brand colors