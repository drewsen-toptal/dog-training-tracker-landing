"use client";

import { useState } from "react";
import { ArrowRight, Loader2, CheckCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

interface WaitlistFormProps {
  variant?: "hero" | "inline";
  className?: string;
}

export function WaitlistForm({ variant = "hero", className = "" }: WaitlistFormProps) {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">("idle");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!email || !email.includes("@")) {
      setStatus("error");
      setMessage("Please enter a valid email address.");
      return;
    }

    // Clear any previous errors
    setStatus("loading");
    setMessage("");

    try {
      const response = await fetch("/api/waitlist", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });

      const data = await response.json();

      if (response.ok) {
        setStatus("success");
        setMessage("You're on the list! We'll notify you when we launch.");
        setEmail("");
      } else {
        setStatus("error");
        setMessage(data.message || "Something went wrong. Please try again.");
      }
    } catch {
      setStatus("error");
      setMessage("Something went wrong. Please try again.");
    }
  };

  if (status === "success") {
    return (
      <div
        className={`flex items-center gap-2 text-primary ${className}`}
        role="status"
        aria-live="polite"
      >
        <CheckCircle className="h-5 w-5" aria-hidden="true" />
        <span className="font-medium">{message}</span>
      </div>
    );
  }

  if (variant === "hero") {
    return (
      <form onSubmit={handleSubmit} className={`flex flex-col gap-3 sm:flex-row ${className}`}>
        <div className="flex-1">
          <Input
            type="email"
            placeholder="Enter your email"
            value={email}
            onChange={(e) => {
              setEmail(e.target.value);
              // Clear error when user starts typing a valid email
              if (status === "error" && e.target.value.includes("@")) {
                setStatus("idle");
                setMessage("");
              }
            }}
            className="h-12 text-base"
            disabled={status === "loading"}
            aria-label="Email address for waitlist"
            aria-invalid={status === "error"}
            aria-describedby={status === "error" ? "email-error" : undefined}
          />
          {status === "error" && (
            <p className="mt-1 text-sm text-destructive" role="alert" aria-live="assertive" id="email-error">{message}</p>
          )}
        </div>
        <Button
          type="submit"
          size="lg"
          className="h-12 px-6"
          disabled={status === "loading"}
        >
          {status === "loading" ? (
            <>
              <Loader2 className="mr-2 h-4 w-4 animate-spin" aria-hidden="true" />
              Joining...
            </>
          ) : (
            <>
              Join Waitlist
              <ArrowRight className="ml-2 h-4 w-4" aria-hidden="true" />
            </>
          )}
        </Button>
      </form>
    );
  }

  return (
    <form onSubmit={handleSubmit} className={`flex gap-2 ${className}`}>
      <Input
        type="email"
        placeholder="your@email.com"
        value={email}
        onChange={(e) => {
          setEmail(e.target.value);
          // Clear error when user starts typing a valid email
          if (status === "error" && e.target.value.includes("@")) {
            setStatus("idle");
            setMessage("");
          }
        }}
        className="h-10"
        disabled={status === "loading"}
        aria-label="Email address for waitlist"
        aria-invalid={status === "error"}
        aria-describedby={status === "error" ? "email-error-inline" : undefined}
      />
      <Button
        type="submit"
        size="sm"
        disabled={status === "loading"}
      >
        {status === "loading" ? (
          <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />
        ) : (
          "Join"
        )}
      </Button>
      {status === "error" && (
        <p className="absolute mt-12 text-sm text-destructive" role="alert" aria-live="assertive" id="email-error-inline">{message}</p>
      )}
    </form>
  );
}
