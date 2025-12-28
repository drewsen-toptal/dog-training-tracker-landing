import { Star } from "lucide-react";

interface StarRatingProps {
  rating?: number;
  maxRating?: number;
  label?: string;
  size?: "sm" | "md" | "lg";
}

const sizeClasses = {
  sm: "h-4 w-4",
  md: "h-5 w-5",
  lg: "h-6 w-6",
};

export function StarRating({
  rating = 5,
  maxRating = 5,
  label,
  size = "md",
}: StarRatingProps) {
  const displayRating = Math.min(rating, maxRating);
  const ariaLabel = label || `${displayRating} out of ${maxRating} stars rating`;

  return (
    <div className="flex gap-1" role="img" aria-label={ariaLabel}>
      {[...Array(displayRating)].map((_, i) => (
        <Star
          key={i}
          className={`${sizeClasses[size]} fill-secondary text-secondary`}
          aria-hidden="true"
        />
      ))}
    </div>
  );
}
