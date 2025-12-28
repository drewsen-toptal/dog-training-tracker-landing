import { NextRequest, NextResponse } from "next/server";

// In production, replace with database or email service (e.g., Mailchimp, ConvertKit)
// WARNING: In-memory storage loses data on server restart - for demo purposes only
const waitlistEmails: string[] = [];

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email } = body;

    // Validate email
    if (!email || typeof email !== "string") {
      return NextResponse.json(
        { success: false, message: "Email is required" },
        { status: 400 }
      );
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { success: false, message: "Invalid email format" },
        { status: 400 }
      );
    }

    // Check for duplicate
    if (waitlistEmails.includes(email.toLowerCase())) {
      return NextResponse.json(
        { success: false, message: "This email is already on the waitlist" },
        { status: 409 }
      );
    }

    // Add to waitlist (in production, save to database or email service)
    waitlistEmails.push(email.toLowerCase());

    // TODO: In production, integrate with email service like:
    // - Mailchimp API
    // - ConvertKit API
    // - Resend API
    // - Or persist to database (Supabase, Vercel KV, etc.)

    return NextResponse.json(
      {
        success: true,
        message: "Successfully joined the waitlist!",
        position: waitlistEmails.length
      },
      { status: 200 }
    );
  } catch {
    return NextResponse.json(
      { success: false, message: "Internal server error" },
      { status: 500 }
    );
  }
}

// GET endpoint removed - exposes sensitive data without authentication
// If needed, implement proper authentication (API key, session, etc.)
