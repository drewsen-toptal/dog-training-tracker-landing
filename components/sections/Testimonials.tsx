import { Star } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";

const testimonials = [
  {
    quote: "When we brought Mochi home, I was completely overwhelmed. Every app I tried wanted my credit card before I could even see what training looked like. Dog Training Tracker let me jump straight in. Within 3 weeks, Mochi learned sit, stay, down, and come. The progress tracking kept me motivated on days when it felt like nothing was working. Looking back at where we started? Night and day.",
    headline: "I finally feel like I know what I'm doing.",
    author: "Jessica T.",
    context: "First-time puppy owner, 8-month-old Goldendoodle",
    result: "4 commands mastered in 3 weeks",
  },
  {
    quote: "I'll be honest, I almost didn't buy it. Another dog app? But the no-subscription thing caught my eye. I was paying $12/month for an app that barely worked offline and kept pushing premium features. This one just... works. Duke went from pulling on every walk to loose-leash walking in about 6 weeks. The session logs helped me see that consistency was more important than session length. Game changer.",
    headline: "Worth every penny. And I only paid once.",
    author: "Marcus L.",
    context: "New dog owner, 1-year-old Lab mix",
    result: "Loose-leash walking in 6 weeks",
  },
  {
    quote: "I have a senior Beagle, a 2-year-old rescue, and a new puppy. Every other app either charged per dog or made me create separate accounts. Dog Training Tracker lets me track all three in one place. I can see that Bruno (the senior) needs refreshers on recall, while Pepper (the puppy) is crushing her crate training. The unlimited dogs feature alone made this worth it.",
    headline: "Finally, one app for all three of my dogs.",
    author: "Rachel & Tom K.",
    context: "3-dog household",
    result: "All three dogs on individualized training plans",
  },
  {
    quote: "We live on 5 acres and our WiFi is... let's call it \"aspirational.\" Most apps are useless out in the field where we actually train. This one works perfectly offline. I can log sessions, use the clicker, review our progress, and everything syncs when I'm back at the house. Our two Border Collies have never been more focused. We've been working on distance commands and they're now reliable at 50+ feet.",
    headline: "The offline mode is everything.",
    author: "David M.",
    context: "2 Border Collies, rural property",
    result: "Reliable off-leash commands at 50+ feet",
  },
  {
    quote: "We adopted Biscuit from a shelter. He came with some baggage, no training history, and a lot of fear. The command library helped us start with basics, but what really mattered was the progress tracking. On hard days, when it felt like we weren't getting anywhere, I could look back and see how far we'd come. It took 4 months, but Biscuit went from cowering at everything to confidently greeting strangers. The notes feature was huge for tracking what triggered him and what helped him feel safe.",
    headline: "Helped us understand our rescue's unique needs.",
    author: "Anika P.",
    context: "Rescue adopter, 3-year-old mixed breed",
    result: "Fear-reactive to confident in 4 months",
  },
];

export function Testimonials() {
  return (
    <section id="testimonials" className="py-16 md:py-20 lg:py-24 bg-muted/30">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        {/* Section Header */}
        <div className="mx-auto mb-12 max-w-2xl text-center md:mb-16">
          <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
            Real Results From Real Dog Owners
          </h2>
          <p className="mt-4 text-muted-foreground">
            See what dog owners just like you have achieved.
          </p>
        </div>

        {/* Testimonials Grid */}
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3 lg:gap-8">
          {testimonials.map((testimonial, index) => (
            <Card
              key={index}
              className={`border-border/50 ${index === 4 ? "md:col-span-2 lg:col-span-1" : ""}`}
            >
              <CardContent className="p-6 md:p-8">
                {/* Star Rating */}
                <div className="mb-4 flex gap-1">
                  {[...Array(5)].map((_, i) => (
                    <Star key={i} className="h-5 w-5 fill-secondary text-secondary" />
                  ))}
                </div>

                {/* Headline */}
                <h3 className="mb-4 text-lg font-semibold text-foreground">
                  &ldquo;{testimonial.headline}&rdquo;
                </h3>

                {/* Quote */}
                <blockquote className="mb-6">
                  <p className="text-sm text-muted-foreground leading-relaxed">
                    {testimonial.quote}
                  </p>
                </blockquote>

                {/* Author */}
                <div className="border-t border-border pt-4">
                  <p className="font-medium text-foreground">{testimonial.author}</p>
                  <p className="text-sm text-muted-foreground">{testimonial.context}</p>
                  <p className="mt-2 text-sm font-medium text-primary">
                    Results: {testimonial.result}
                  </p>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Trust Badges */}
        <div className="mt-12 flex flex-wrap items-center justify-center gap-6">
          <div className="flex items-center gap-2">
            <div className="flex gap-0.5">
              {[...Array(5)].map((_, i) => (
                <Star key={i} className="h-4 w-4 fill-secondary text-secondary" />
              ))}
            </div>
            <span className="text-sm font-medium">4.9 stars on App Store</span>
          </div>
          <div className="h-4 w-px bg-border" />
          <span className="text-sm font-medium">500+ founding members</span>
          <div className="h-4 w-px bg-border" />
          <span className="text-sm font-medium">30-day money-back guarantee</span>
        </div>
      </div>
    </section>
  );
}
